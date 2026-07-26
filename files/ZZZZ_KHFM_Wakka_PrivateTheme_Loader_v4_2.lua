-- Kingdom Hearts Final Mix (Steam Global)
-- File: ZZZZ_KHFM_Wakka_PrivateTheme_Loader_v4_2.lua
-- Enemy-specific private battle-theme loader / Wakka test v4.2
--
-- Verified target:
--   KINGDOM HEARTS FINAL MIX.exe
--   Steam Global 1.0.0.2
--   SHA-256 d790746245d26159f3ee0e1060e33b2fa2de06941850a4ac724f598722884bac
--   PE TimeDateStamp 0x669E37CE
--   LuaBackendHook v1.9.1-hook / LuaEngine v5.0
--
-- TEST ROUTE
--   Enemy:       Wakka
--   Native BGM:  music119.win32.scd
--   Replacement: music110.win32.scd
--
-- The script does not overwrite either game SCD file. When Wakka is
-- positively detected, Lua reads the private SCD beside this script. A
-- two-stage main-thread dispatcher allocates the native audio buffer with
-- KH1's own 16-byte-aligned allocator, receives the verified SCD bytes from
-- Lua, registers the live buffer on Wakka's BGM slot 1, and starts it.
--
-- Wakka identification is deliberately composite:
--   * world=1 and room=0
--   * model code xa_di_1030 or xa_di_1039; or
--   * native/known-test HP plus the verified MOBJ fingerprint
--
-- The fingerprint alone is never accepted. Runtime tests proved that Wakka's
-- 18-HP projectile/transient object can expose the same fingerprint.
--
-- v2 correction:
--   The v1 report proved music105 began 15.684 seconds before the first safe
--   Wakka identity became visible. A future-request-only redirect therefore
--   armed correctly but never changed the already-playing battle track.
--   The later design uses a one-shot main-thread dispatcher. When Wakka is
--   first confirmed while music105 is already active, the dispatcher loads
--   and starts music110 on the next frame. The encounter stays latched until
--   the verified world/room is left, so a temporary loss of lock-on cannot
--   undo the encounter state after three seconds.
--
-- This script does not include the v8 BGM recorder. Remove
-- ZZZZ_KH1FM_BGM_Identifier_Recorder_v8.lua before using this file because
-- it competes for the same only-known executable padding range. Fully restart
-- the game after adding, removing, or replacing either script.
--
-- v2.1 correction:
--   Lua 5.1 limits one function to 200 simultaneous local variables. V2's
--   main chunk crossed that limit when its final runtime helpers were
--   declared. Those late helpers now live as private fields on SETTINGS,
--   reducing the main chunk below the compiler limit without changing the
--   hook, detection, encounter-latch, or playback-dispatch behavior.
--
-- v2.2 correction:
--   The verified executable has only one unclaimed 288-byte code-padding
--   range. V2.1 independently requested 261 bytes for the BGM wrapper and
--   another 117 bytes for frame dispatch, so its second allocation always
--   failed. V2.2 uses a Wakka-only 181-byte BGM wrapper and a 103-byte frame
--   dispatcher packed into that single range (284 bytes total). The Enemy
--   Stats Manager's separate 0x3AF150-0x3AF200 cave remains excluded.
--
-- v2.4 correction:
--   V2.3 still reused a resource handle from music110's earlier title/scene
--   playback. The handle value remained nonzero after its backing resource
--   was unloaded, so the diagnostic hook reported a redirect even though the
--   game had no live audio buffer and silence followed. V2.4 removes that
--   synthetic routing entirely. Its 274-byte dispatcher loads music110 on
--   demand, registers the returned live buffer, and reports distinct
--   file-manager/load/register/completion states.
--
-- v4.2 correction:
--   V4.1 proved that OpenKH preserved the private SCD and Lua could read it,
--   but LoadFileWithMalloc returned no buffer because that function accepts
--   game-package paths rather than arbitrary disk paths. V4.2 reads the SCD
--   through Lua, allocates with the same aligned allocator used by KH1's
--   original file loader, copies and verifies it in bounded chunks, then
--   registers and plays it on Wakka's verified slot 1. The menu's original
--   music110 resource remains untouched.

LUAGUI_NAME = "KH1FM Wakka Private Theme Loader v4.2"
LUAGUI_AUTH = "OpenAI"
LUAGUI_DESC = "Loads a private SCD only when Wakka is confirmed"

-- =========================================================================
-- EDITABLE SETTINGS
-- =========================================================================

local SETTINGS = {
    ENABLE = true,
    SOURCE_BGM = "music119.win32.scd",
    REPLACEMENT_BGM = "music110.win32.scd",
    PRIVATE_SCD_FILENAME = "KHFM_WakkaTheme.win32.scd",
    PRIVATE_SCD_PATH = nil,
    PRIVATE_SCD_SIZE = nil,
    COPY_CHUNK_SIZE = 0x10000,

    WAKKA_WORLD = 1,
    WAKKA_ROOM = 0,
    WAKKA_NATIVE_MAX_HP = 75,
    -- If Wakka is still using the manager's current global 4x fallback when
    -- this script sees him, 75 becomes 300.
    WAKKA_GLOBAL_4X_MAX_HP = 300,
    -- Enemy Stats Manager v2.6 currently changes Wakka's verified 75 HP to
    -- this exact test value. If that manager setting is edited, model-code
    -- identification remains the preferred route.
    WAKKA_MANAGER_TEST_MAX_HP = 500,
    WAKKA_FINGERPRINT =
        "000745F8:00000070:0001C000:0004B000:009A:0007",
    WAKKA_MODEL_CODES = {
        ["xa_di_1030"] = true,
        ["xa_di_1039"] = true,
    },

    -- The short hold covers gaps before the encounter latch is established.
    -- Once Wakka is positively identified, the latch remains active until the
    -- primary native BGM changes or the verified world/room is left.
    PRESENCE_HOLD_TICKS = 180,
    PRIMARY_BGM_ID = 1,

    REPORT_FILENAME = "KHFM_Wakka_Private_Theme_v4_2_Report.txt",
    ECHO_ALL_BGM_TO_F2 = false,
    REPORT_SAVE_INTERVAL_TICKS = 60,
    MAX_TIMELINE_ROWS = 20000,
}

-- =========================================================================
-- VERIFIED BUILD, BGM ROUTE, AND ENTITY LAYOUT
-- =========================================================================

local POINTER_RESOLVER_RVA = 0x38ADC0
local POINTER_RESOLVER_SIGNATURE = {
    0x85, 0xC9, 0x75, 0x03, 0x33, 0xC0,
    0xC3, 0xE9, 0x74, 0x01, 0x00, 0x00,
}

local BGM_FUNCTION_RVA = 0x000DD5C0
local BGM_FUNCTION_SIGNATURE = {
    0x48, 0x8B, 0xC4, 0x41, 0x56,
    0x48, 0x81, 0xEC, 0x80, 0x00, 0x00, 0x00,
    0x48, 0xC7, 0x40, 0xA8,
}

local BGM_STOP_FUNCTION_RVA = 0x000DD7F0
local BGM_STOP_FUNCTION_SIGNATURE = {
    0x40, 0x53, 0x48, 0x83, 0xEC, 0x20,
    0x48, 0x83, 0x3D, 0xDA, 0xD7, 0x0C, 0x02, 0x00,
}

-- Native callers take this file-manager lock around BGM-resource
-- registration. V4.2 follows that same main-thread sequence.
local FILE_MANAGER_POINTER_RVA = 0x021AAE40
local FILE_MANAGER_LOCK_RVA = 0x000E43B0
local FILE_MANAGER_LOCK_SIGNATURE = {
    0x48, 0x8B, 0x49, 0x18, 0xBA, 0xFF, 0xFF, 0xFF, 0xFF,
}
local FILE_MANAGER_UNLOCK_RVA = 0x000E42A0
local FILE_MANAGER_UNLOCK_SIGNATURE = {
    0x48, 0x83, 0xEC, 0x28, 0x48, 0x8B, 0x49, 0x18,
}
-- KH1's original LoadFileWithMalloc implementation calls the imported
-- 16-byte-aligned allocator and matching free function at these IAT entries.
-- The call-site signatures prevent using them on an unsupported executable.
local ALIGNED_MALLOC_IAT_RVA = 0x003B0778
local ALIGNED_FREE_IAT_RVA = 0x003B0780
local ALIGNED_MALLOC_CALL_RVA = 0x000D582D
local ALIGNED_MALLOC_CALL_SIGNATURE = {
    0xFF, 0x15, 0x45, 0xAF, 0x2D, 0x00,
}
local ALIGNED_FREE_CALL_RVA = 0x000D584D
local ALIGNED_FREE_CALL_SIGNATURE = {
    0xFF, 0x15, 0x2D, 0xAF, 0x2D, 0x00,
}
local REGISTER_BGM_RESOURCE_RVA = 0x000E0F00
local REGISTER_BGM_RESOURCE_SIGNATURE = {
    0x40, 0x57, 0x41, 0x56, 0x41, 0x57, 0x48, 0x83, 0xEC, 0x40,
}

-- LuaBackend Hook finds this same app pointer and replaces vtable slot 4 with
-- its frame hook. V2 wraps that already-installed target and tail-jumps back
-- to it after servicing a one-shot BGM request on the game thread.
local FRAME_APP_SIGNATURE_RVA = 0x000D6A12
local FRAME_APP_SIGNATURE = {
    0x48, 0x89, 0x35, 0xFF, 0x44, 0x0D, 0x02,
    0x48, 0x8B, 0xC6,
}
local FRAME_APP_POINTER_RVA = 0x021AAF18
local FRAME_VTABLE_SLOT_OFFSET = 0x20

local SORA_POINTER = 0x2537E48
local LOCK_ON_TARGET_POINTER = 0x25387F0
local NATIVE_RAGNAROK_SORA_POINTER = 0x2D37280
local POINTER_BANK_TABLE = 0x2EE3980
local ROOM_ADDRESS = 0x233FE8C
local WORLD_ADDRESS = 0x233FE94

local SORA_LOCK_ON_TARGET_OFFSET = 0x74
local ENTITY_STAT_PAGE_OFFSET = 0x6C
local ENTITY_MOBJ_POINTER_OFFSET = 0x154
local STAT_CURRENT_HP_OFFSET = 0x3C
local STAT_MAX_HP_OFFSET = 0x40

local MOBJ_MAGIC = 0x4A424F4D
local MOBJ_DATA_SIZE_OFFSET = 0x04
local MOBJ_TEXTURE_INFO_SIZE_OFFSET = 0x0C
local MOBJ_TEXTURE_DATA_SIZE_OFFSET = 0x14
local MOBJ_MODEL_POINTER_OFFSET = 0x20
local MOBJ_MODEL_SIZE_OFFSET = 0x24
local MODEL_JOINT_COUNT_OFFSET = 0x00
local MODEL_MESH_COUNT_OFFSET = 0x0C

local TARGET_GLOBAL_SCAN_START = 0x2538000
local TARGET_GLOBAL_SCAN_LENGTH = 0x1000
local TARGET_GLOBAL_SLOTS_PER_TICK = 32
local GRAPH_RESCAN_INTERVAL_TICKS = 120
local GRAPH_NODES_PER_TICK = 8
local MAX_GRAPH_NODES = 1536
local MAX_MODEL_REFERENCE_PROBES = 64
local MAX_HP_STORAGE_VALUE = 2147483647

-- =========================================================================
-- ON-DEMAND BGM DISPATCH IMAGE AND DATA LAYOUT
-- =========================================================================

local DATA_TARGET_RESOURCE_OFFSET = 0x088
local DATA_TARGET_NAME_OFFSET = 0x0A0
local DATA_DISPATCH_STATUS_OFFSET = 0x0E8
local DATA_LOAD_SIZE_OFFSET = 0x0EC
local DATA_LOAD_BUFFER_OFFSET = 0x0F0
local DATA_COPY_PROGRESS_OFFSET = 0x100
local DATA_DISPATCH_COMMAND_OFFSET = 0x108
local DATA_DISPATCH_VOLUME_BITS_OFFSET = 0x110
local DATA_DISPATCH_FADE_BITS_OFFSET = 0x114
local DATA_DISPATCH_TIME_OFFSET = 0x118
local DATA_DISPATCH_COUNTER_OFFSET = 0x11C
local DATA_ORIGINAL_FRAME_POINTER_OFFSET = 0x120
local DATA_FRAME_VTABLE_SLOT_OFFSET = 0x130
local DATA_MAGIC_OFFSET = 0x138
local DATA_SOURCE_NAME_OFFSET = 0x140
local DATA_MAGIC = "BGMW42\0\0"
local DATA_SIZE = 0x160

-- The executable has one 288-byte safe code cave. V4.2 first installs a
-- compact 91-byte allocator stage. After Lua finishes the verified chunked
-- copy, it replaces that same cave with the 283-byte register/play stage.
local ALLOCATION_CODE_HEX =
    "514883ec40833d00000000017542c7050000000000000000c6050000000001"
    .. "8b0d0000000085c97420ba10000000ff1500000000488905000000004885c0"
    .. "7409c6050000000002eb07c60500000000034883c44059ff2500000000"
local ALLOCATION_CODE_SIZE = 0x05B
local ALLOCATION_RELOCATIONS = {
    { field = 0x007, next = 0x00C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x010, next = 0x018,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x01A, next = 0x01F,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x021, next = 0x025, data = DATA_LOAD_SIZE_OFFSET },
    { field = 0x030, next = 0x034, absolute = ALIGNED_MALLOC_IAT_RVA },
    { field = 0x037, next = 0x03B, data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x042, next = 0x047,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x04B, next = 0x050,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x057, next = 0x05B,
        data = DATA_ORIGINAL_FRAME_POINTER_OFFSET },
}

local REGISTER_CODE_HEX =
    "514883ec40833d00000000020f85fe000000c7050000000000000000c60500"
    .. "000000044c8b05000000004d85c00f84a7000000448b0d000000004585c90f"
    .. "8497000000488b0d000000004885c90f8490000000e800000000488d0d0000"
    .. "0000ba010000004c8b0500000000448b0d00000000e8000000008905000000"
    .. "00488b0d00000000e800000000833d0000000000745ab901000000e8000000"
    .. "00b9010000004531c0448b0d00000000f30f100d00000000f30f1015000000"
    .. "004c894424204c89442428e800000000f0ff0500000000c6050000000007eb"
    .. "36c6050000000003eb2dc6050000000005eb07c6050000000006488b0d0000"
    .. "00004885c97411ff150000000048c70500000000000000004883c44059ff25"
    .. "00000000"
local REGISTER_CODE_SIZE = 0x11B
local REGISTER_RELOCATIONS = {
    { field = 0x007, next = 0x00C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x014, next = 0x01C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x01E, next = 0x023,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x026, next = 0x02A, data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x036, next = 0x03A, data = DATA_LOAD_SIZE_OFFSET },
    { field = 0x046, next = 0x04A, absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x054, next = 0x058, absolute = FILE_MANAGER_LOCK_RVA },
    { field = 0x05B, next = 0x05F, data = DATA_TARGET_NAME_OFFSET },
    { field = 0x067, next = 0x06B, data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x06E, next = 0x072, data = DATA_LOAD_SIZE_OFFSET },
    { field = 0x073, next = 0x077, absolute = REGISTER_BGM_RESOURCE_RVA },
    { field = 0x079, next = 0x07D,
        data = DATA_TARGET_RESOURCE_OFFSET },
    { field = 0x080, next = 0x084, absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x085, next = 0x089, absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x08B, next = 0x090,
        data = DATA_TARGET_RESOURCE_OFFSET },
    { field = 0x098, next = 0x09C, absolute = BGM_STOP_FUNCTION_RVA },
    { field = 0x0A7, next = 0x0AB, data = DATA_DISPATCH_TIME_OFFSET },
    { field = 0x0AF, next = 0x0B3,
        data = DATA_DISPATCH_VOLUME_BITS_OFFSET },
    { field = 0x0B7, next = 0x0BB,
        data = DATA_DISPATCH_FADE_BITS_OFFSET },
    { field = 0x0C6, next = 0x0CA, absolute = BGM_FUNCTION_RVA },
    { field = 0x0CD, next = 0x0D1,
        data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x0D3, next = 0x0D8,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0DC, next = 0x0E1,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0E5, next = 0x0EA,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0EE, next = 0x0F3,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0F6, next = 0x0FA, data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x101, next = 0x105, absolute = ALIGNED_FREE_IAT_RVA },
    { field = 0x108, next = 0x110, data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x117, next = 0x11B,
        data = DATA_ORIGINAL_FRAME_POINTER_OFFSET },
}
local FRAME_CODE_CAPACITY = REGISTER_CODE_SIZE
local FRAME_CODE_PREFIX = {
    0x51, 0x48, 0x83, 0xEC, 0x40,
}

-- Enemy Stats Manager v2.x owns this verified executable cave.
local RESERVED_RANGES = {
    { first = 0x3AF150, last = 0x3AF200 },
}

local IMAGE_SCN_MEM_EXECUTE = 0x20000000
local IMAGE_SCN_MEM_WRITE = 0x80000000

-- =========================================================================
-- RUNTIME STATE
-- =========================================================================

local enabled = false
local tick = 0
local sections = {}
local sizeOfImage = 0
local moduleBase = 0
local codeRva = 0
local frameCodeRva = 0
local dataRva = 0
local frameVtableSlot = 0
local originalFramePointer = 0
local frameDispatcherInstalled = false

local currentSora = 0
local wakkaLastSeenTick = -100000
local wakkaPresent = false
local wakkaMatchSource = nil
local redirectFlagPublished = -1
local wakkaEncounterLatched = false
local activeSwitchQueued = false
local activeSwitchAttempted = false

local graphQueue = {}
local graphQueueHead = 1
local graphQueued = {}
local graphScanned = {}
local graphNodesQueued = 0
local lastGraphRestartTick = -100000
local globalScanOffset = 0

local lastDispatchCounter = 0
local lastDispatchStatus = 0
local lastLoadSize = 0
local lastLoadBuffer = 0
local lastTargetResource = 0
local totalActiveSwitches = 0
local timelineRows = {}
local timelineCapped = false
local statusLines = {}
local primaryVolumeBits = 0x3F400000
local primaryFadeBits = 0x3F400000
local primaryTime = 0
local reportDirty = false
local lastReportSaveTick = 0

-- =========================================================================
-- LOGGING AND REPORT
-- =========================================================================

local function console(message)
    ConsolePrint("[WakkaThemeV4.2] " .. message)
end

local function addStatus(message, echo)
    statusLines[#statusLines + 1] = message
    reportDirty = true
    if echo then
        console(message)
    end
end

local function addTimeline(message, echo)
    if #timelineRows < SETTINGS.MAX_TIMELINE_ROWS then
        timelineRows[#timelineRows + 1] = message
    elseif not timelineCapped then
        timelineCapped = true
        console("TIMELINE LIMIT REACHED: counters continue.")
    end
    reportDirty = true
    if echo then
        console(message)
    end
end

local function buildReport()
    local lines = {
        "KH1FM Wakka Private Theme Test v4.2 report",
        "Target: KINGDOM HEARTS FINAL MIX.exe / Steam Global 1.0.0.2",
        "Enemy route: Wakka",
        "Source BGM: " .. SETTINGS.SOURCE_BGM,
        "Replacement BGM: " .. SETTINGS.REPLACEMENT_BGM,
        "Detection: world=1 room=0 plus model code or HP/fingerprint composite.",
        "Fingerprint-only routing is forbidden because the 18-HP projectile reuses it.",
        "Playback: Lua copies the private SCD into a native aligned buffer; KH1 registers and plays it only when Wakka is confirmed.",
        "Private SCD path: " .. tostring(SETTINGS.PRIVATE_SCD_PATH),
        "Private SCD size: " .. tostring(SETTINGS.PRIVATE_SCD_SIZE or 0),
        "Playback slot: " .. tostring(SETTINGS.PRIMARY_BGM_ID),
        "Latch: a confirmed Wakka encounter remains armed until context changes.",
        "",
        "SUMMARY",
        string.format(
            "On-demand BGM switches completed: %u",
            totalActiveSwitches
        ),
        string.format(
            "Last dispatcher status: %u",
            lastDispatchStatus
        ),
        string.format(
            "Last load size: %u",
            lastLoadSize
        ),
        string.format("Last load buffer: 0x%X", lastLoadBuffer),
        string.format(
            "Verified bytes copied: %u",
            SETTINGS._copyOffset or 0
        ),
        string.format(
            "Last registered resource: 0x%08X",
            lastTargetResource
        ),
        "Wakka currently present: " .. tostring(wakkaPresent),
        "Wakka encounter latched: " .. tostring(wakkaEncounterLatched),
        "Last Wakka match source: " .. tostring(wakkaMatchSource or "none"),
        "",
        "STARTUP / STATUS",
    }

    for _, line in ipairs(statusLines) do
        lines[#lines + 1] = line
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "TIMELINE"
    if #timelineRows == 0 then
        lines[#lines + 1] = "<no runtime event observed yet>"
    else
        for _, line in ipairs(timelineRows) do
            lines[#lines + 1] = line
        end
    end
    if timelineCapped then
        lines[#lines + 1] =
            "TIMELINE LIMIT REACHED: counters continued after this point."
    end
    return lines
end

local function saveReport()
    if not reportDirty then
        return
    end
    if io == nil or io.open == nil or SCRIPT_PATH == nil then
        return
    end
    local file = io.open(
        SCRIPT_PATH .. "\\" .. SETTINGS.REPORT_FILENAME,
        "w"
    )
    if file == nil then
        return
    end
    file:write(table.concat(buildReport(), "\n"))
    file:write("\n")
    file:close()
    reportDirty = false
    lastReportSaveTick = tick
end

-- =========================================================================
-- SAFE MEMORY HELPERS
-- =========================================================================

local function unsigned16(value)
    if value == nil then
        return nil
    end
    if value < 0 then
        return value + 65536
    end
    return value
end

local function unsigned32(value)
    if value == nil then
        return nil
    end
    if value < 0 then
        return value + 4294967296
    end
    return value
end

local function signed32(value)
    if value == nil then
        return 0
    end
    if value >= 2147483648 then
        return value - 4294967296
    end
    return value
end

local function safeReadByte(address, absolute)
    local ok
    local value
    if absolute == nil then
        ok, value = pcall(ReadByte, address)
    else
        ok, value = pcall(ReadByte, address, absolute)
    end
    if not ok or value == nil then
        return nil
    end
    if value < 0 then
        return value + 256
    end
    return value
end

local function safeReadShort(address)
    local ok, value = pcall(ReadShort, address)
    if not ok or value == nil then
        return nil
    end
    return unsigned16(value)
end

local function safeReadInt(address, absolute)
    local ok
    local value
    if absolute == nil then
        ok, value = pcall(ReadInt, address)
    else
        ok, value = pcall(ReadInt, address, absolute)
    end
    if not ok or value == nil then
        return nil
    end
    return unsigned32(value)
end

local function safeReadLong(address, absolute)
    local ok
    local value
    if absolute == nil then
        ok, value = pcall(ReadLong, address)
    else
        ok, value = pcall(ReadLong, address, absolute)
    end
    if not ok or value == nil then
        return nil
    end
    return value
end

local function safeReadArray(address, length, absolute)
    local ok
    local value
    if absolute == nil then
        ok, value = pcall(ReadArray, address, length)
    else
        ok, value = pcall(ReadArray, address, length, absolute)
    end
    if not ok or value == nil or #value < length then
        return nil
    end
    return value
end

local function safeReadString(address, length)
    local ok, value = pcall(ReadString, address, length)
    if not ok or value == nil then
        return nil
    end
    return value
end

local function arraysEqual(left, right)
    if left == nil or right == nil or #left ~= #right then
        return false
    end
    for index = 1, #left do
        if left[index] ~= right[index] then
            return false
        end
    end
    return true
end

local function writeArrayChecked(address, bytes)
    local ok, reason = pcall(WriteArray, address, bytes)
    if not ok then
        return false, tostring(reason)
    end
    if not arraysEqual(safeReadArray(address, #bytes), bytes) then
        return false, "write did not verify"
    end
    return true
end

local function writeArrayAbsoluteChecked(address, bytes)
    local ok, reason = pcall(WriteArray, address, bytes, true)
    if not ok then
        return false, tostring(reason)
    end
    if not arraysEqual(
        safeReadArray(address, #bytes, true),
        bytes
    ) then
        return false, "absolute write did not verify"
    end
    return true
end

local function writeIntChecked(address, value)
    local ok, reason = pcall(WriteInt, address, value)
    if not ok then
        return false, tostring(reason)
    end
    if safeReadInt(address) ~= unsigned32(value) then
        return false, "integer write did not verify"
    end
    return true
end

local function writeLongChecked(address, value)
    local ok, reason = pcall(WriteLong, address, value)
    if not ok then
        return false, tostring(reason)
    end
    if safeReadLong(address) ~= value then
        return false, "pointer write did not verify"
    end
    return true
end

local function writeLongAbsoluteChecked(address, value)
    local ok, reason = pcall(WriteLong, address, value, true)
    if not ok then
        return false, tostring(reason)
    end
    if safeReadLong(address, true) ~= value then
        return false, "absolute pointer write did not verify"
    end
    return true
end

local function hasFlag(value, flag)
    if value == nil or flag == nil or flag <= 0 then
        return false
    end
    return math.floor(value / flag) % 2 == 1
end

local function rangesOverlap(firstA, lastA, firstB, lastB)
    return firstA < lastB and firstB < lastA
end

local function isExcluded(first, last, extraRanges)
    for _, range in ipairs(RESERVED_RANGES) do
        if rangesOverlap(first, last, range.first, range.last) then
            return true
        end
    end
    if extraRanges ~= nil then
        for _, range in ipairs(extraRanges) do
            if rangesOverlap(first, last, range.first, range.last) then
                return true
            end
        end
    end
    return false
end

local function putU32(bytes, offset, value)
    local number = value % 4294967296
    for byteIndex = 0, 3 do
        bytes[offset + byteIndex + 1] = number % 256
        number = math.floor(number / 256)
    end
end

local function putU64(bytes, offset, value)
    putU32(bytes, offset, value % 4294967296)
    putU32(bytes, offset + 4, math.floor(value / 4294967296))
end

local function putString(bytes, offset, capacity, value)
    local length = math.min(string.len(value), capacity - 1)
    for index = 1, length do
        bytes[offset + index] = string.byte(value, index)
    end
    bytes[offset + length + 1] = 0
end

local function bytesFromHex(hex)
    local bytes = {}
    local position = 1
    while position <= string.len(hex) do
        bytes[#bytes + 1] =
            tonumber(string.sub(hex, position, position + 1), 16)
        position = position + 2
    end
    return bytes
end

local function rel32(target, nextInstruction)
    local difference = target - nextInstruction
    if difference < -2147483648 or difference > 2147483647 then
        return nil
    end
    return difference % 4294967296
end

local function floatFromBits(bits)
    if bits == nil then
        return 0
    end
    local sign = 1
    if bits >= 2147483648 then
        sign = -1
        bits = bits - 2147483648
    end
    local exponent = math.floor(bits / 8388608)
    local fraction = bits % 8388608
    if exponent == 255 then
        if fraction == 0 then
            return sign * math.huge
        end
        return 0 / 0
    end
    if exponent == 0 then
        if fraction == 0 then
            return sign * 0
        end
        return sign * (fraction / 8388608) * (2 ^ -126)
    end
    return sign
        * (1 + fraction / 8388608)
        * (2 ^ (exponent - 127))
end

local function formatFloat(value)
    if value ~= value then
        return "nan"
    end
    if value == math.huge then
        return "inf"
    end
    if value == -math.huge then
        return "-inf"
    end
    return string.format("%.3f", value)
end

local function counterDelta(current, previous)
    if current >= previous then
        return current - previous
    end
    return (4294967296 - previous) + current
end

local function bytesU32(bytes, index)
    return (bytes[index] or 0)
        + (bytes[index + 1] or 0) * 256
        + (bytes[index + 2] or 0) * 65536
        + (bytes[index + 3] or 0) * 16777216
end

local function bytesU64(bytes, index)
    return bytesU32(bytes, index)
        + bytesU32(bytes, index + 4) * 4294967296
end

local function plausibleRuntimeAddress(address)
    return address ~= nil
        and address >= 0x10000
        and address < 0x0000800000000000
        and address % 4 == 0
end

local function addressKey(value)
    return string.format("%.0f", value or 0)
end

local function resolveCompressedPointer(encoded)
    local value = unsigned32(encoded)
    if value == nil or value == 0 then
        return 0
    end
    if value < 0x80000000 then
        return value
    end
    local payload = value - 0x80000000
    local bankIndex = math.floor(payload / 0x2000000)
    local bankOffset = payload % 0x2000000
    local bankBase = safeReadLong(POINTER_BANK_TABLE + bankIndex * 8)
    if bankBase == nil or bankBase == 0 then
        return 0
    end
    return bankBase + bankOffset
end

-- =========================================================================
-- PE IMAGE AND HOOK INSTALLATION
-- =========================================================================

local function parsePeImage()
    if safeReadShort(0) ~= 0x5A4D then
        return false, "DOS header signature mismatch"
    end
    local peOffset = safeReadInt(0x3C)
    if peOffset == nil or safeReadInt(peOffset) ~= 0x00004550 then
        return false, "PE header signature mismatch"
    end
    local numberOfSections = safeReadShort(peOffset + 6)
    local optionalHeaderSize = safeReadShort(peOffset + 20)
    local optionalHeader = peOffset + 24
    if numberOfSections == nil
        or optionalHeaderSize == nil
        or safeReadShort(optionalHeader) ~= 0x20B
    then
        return false, "64-bit optional header mismatch"
    end
    sizeOfImage = safeReadInt(optionalHeader + 0x38) or 0
    if sizeOfImage <= 0 then
        return false, "invalid SizeOfImage"
    end

    sections = {}
    local sectionTable = optionalHeader + optionalHeaderSize
    for index = 0, numberOfSections - 1 do
        local header = sectionTable + index * 40
        local virtualAddress = safeReadInt(header + 12) or 0
        if virtualAddress > 0 and virtualAddress < sizeOfImage then
            sections[#sections + 1] = {
                virtualSize = safeReadInt(header + 8) or 0,
                virtualAddress = virtualAddress,
                rawSize = safeReadInt(header + 16) or 0,
                characteristics = safeReadInt(header + 36) or 0,
            }
        end
    end
    if #sections == 0 then
        return false, "no PE sections were parsed"
    end
    return true
end

local function zeroRunAt(bytes, startIndex, length)
    for index = startIndex, startIndex + length - 1 do
        if bytes[index] ~= 0 then
            return false
        end
    end
    return true
end

local function findRawPaddingCave(
    minimumSize,
    alignment,
    requireExecutable,
    requireWritable,
    extraRanges
)
    for _, section in ipairs(sections) do
        local executable = hasFlag(
            section.characteristics,
            IMAGE_SCN_MEM_EXECUTE
        )
        local writable = hasFlag(
            section.characteristics,
            IMAGE_SCN_MEM_WRITE
        )
        if (not requireExecutable or executable)
            and (not requireWritable or writable)
            and section.rawSize > section.virtualSize
        then
            local slackStart =
                section.virtualAddress + section.virtualSize
            local slackEnd = math.min(
                section.virtualAddress + section.rawSize,
                sizeOfImage
            )
            local slackLength = slackEnd - slackStart
            if slackLength >= minimumSize then
                local bytes = safeReadArray(slackStart, slackLength)
                if bytes ~= nil then
                    local offset = slackLength - minimumSize
                    while offset >= 0 do
                        local candidate = slackStart + offset
                        if candidate % alignment == 0
                            and not isExcluded(
                                candidate,
                                candidate + minimumSize,
                                extraRanges
                            )
                            and zeroRunAt(bytes, offset + 1, minimumSize)
                        then
                            return candidate
                        end
                        offset = offset - 1
                    end
                end
            end
        end
    end
    return nil
end

local function buildFrameCode(hex, expectedSize, relocations)
    local code = bytesFromHex(hex)
    if #code ~= expectedSize then
        return nil, "embedded frame-dispatch size mismatch"
    end
    for _, relocation in ipairs(relocations) do
        local target = relocation.absolute
            or (dataRva + relocation.data)
        local displacement = rel32(
            target,
            frameCodeRva + relocation.next
        )
        if displacement == nil then
            return nil, "frame-dispatch rel32 target is out of range"
        end
        putU32(code, relocation.field, displacement)
    end
    return code
end

local function buildHookData()
    local data = {}
    for index = 1, DATA_SIZE do
        data[index] = 0
    end
    putString(
        data,
        DATA_SOURCE_NAME_OFFSET,
        0x20,
        SETTINGS.SOURCE_BGM
    )
    putString(
        data,
        DATA_TARGET_NAME_OFFSET,
        0x20,
        SETTINGS.REPLACEMENT_BGM
    )
    putU32(data, DATA_LOAD_SIZE_OFFSET, SETTINGS.PRIVATE_SCD_SIZE)
    putU32(data, DATA_COPY_PROGRESS_OFFSET, 0)
    putU64(
        data,
        DATA_ORIGINAL_FRAME_POINTER_OFFSET,
        originalFramePointer
    )
    putU32(data, 0x128, frameCodeRva)
    putU32(data, 0x12C, FRAME_CODE_CAPACITY)
    putU64(data, DATA_FRAME_VTABLE_SLOT_OFFSET, frameVtableSlot)
    for index = 1, string.len(DATA_MAGIC) do
        data[DATA_MAGIC_OFFSET + index] =
            string.byte(DATA_MAGIC, index)
    end
    return data
end

local function resolveFrameHookTarget()
    if not arraysEqual(
        safeReadArray(
            FRAME_APP_SIGNATURE_RVA,
            #FRAME_APP_SIGNATURE
        ),
        FRAME_APP_SIGNATURE
    ) then
        return false, "LuaBackend app-pointer signature mismatch"
    end
    local app = safeReadLong(FRAME_APP_POINTER_RVA)
    if not plausibleRuntimeAddress(app) then
        return false, "game application pointer is unavailable"
    end
    local vtable = safeReadLong(app, true)
    if not plausibleRuntimeAddress(vtable) then
        return false, "game application vtable is unavailable"
    end
    frameVtableSlot = vtable + FRAME_VTABLE_SLOT_OFFSET
    originalFramePointer = safeReadLong(frameVtableSlot, true) or 0
    if not plausibleRuntimeAddress(originalFramePointer) then
        return false, "LuaBackend frame-hook pointer is unavailable"
    end
    if originalFramePointer >= moduleBase
        and originalFramePointer < moduleBase + sizeOfImage
    then
        return false,
            "application frame slot still points into the game module; "
                .. "LuaBackend Hook is not active"
    end
    return true
end

local function installHooks()
    local occupied = {}
    frameCodeRva = findRawPaddingCave(
        FRAME_CODE_CAPACITY,
        16,
        true,
        false,
        occupied
    )
    if frameCodeRva == nil then
        return false,
            "no safe executable cave was available for the packed "
                .. "283-byte private-theme dispatcher; remove older "
                .. "Wakka theme scripts and BGM Recorder v8, then restart"
    end
    codeRva = frameCodeRva
    occupied[#occupied + 1] = {
        first = frameCodeRva,
        last = frameCodeRva + FRAME_CODE_CAPACITY,
    }
    dataRva = findRawPaddingCave(
        DATA_SIZE,
        8,
        false,
        true,
        occupied
    )
    if dataRva == nil then
        return false, "no safe writable raw-padding cave was available"
    end

    local frameCode, frameCodeReason = buildFrameCode(
        ALLOCATION_CODE_HEX,
        ALLOCATION_CODE_SIZE,
        ALLOCATION_RELOCATIONS
    )
    if frameCode == nil then
        return false, frameCodeReason
    end
    local data = buildHookData()
    local ok
    local reason
    ok, reason = writeArrayChecked(dataRva, data)
    if not ok then
        return false, "hook data install failed: " .. reason
    end
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "frame-dispatch install failed: " .. reason
    end
    SETTINGS._frameStage = "allocation"
    return true, string.format(
        "installed Wakka private-theme allocation stage "
            .. "frame_code=0x%X size=%u capacity=%u data=0x%X",
        frameCodeRva,
        ALLOCATION_CODE_SIZE,
        FRAME_CODE_CAPACITY,
        dataRva
    )
end

function SETTINGS._installRegisterStage()
    local frameCode, reason = buildFrameCode(
        REGISTER_CODE_HEX,
        REGISTER_CODE_SIZE,
        REGISTER_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    local ok
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "register/play stage install failed: " .. reason
    end
    SETTINGS._frameStage = "register"
    return true
end

local function activateFrameDispatcher()
    local frameOK, frameReason = resolveFrameHookTarget()
    if not frameOK then
        return false, frameReason
    end
    local ok
    local reason
    ok, reason = writeLongChecked(
        dataRva + DATA_ORIGINAL_FRAME_POINTER_OFFSET,
        originalFramePointer
    )
    if not ok then
        return false, "original frame-pointer publish failed: " .. reason
    end
    ok, reason = writeLongChecked(
        dataRva + DATA_FRAME_VTABLE_SLOT_OFFSET,
        frameVtableSlot
    )
    if not ok then
        return false, "frame-vtable slot publish failed: " .. reason
    end
    ok, reason = writeLongAbsoluteChecked(
        frameVtableSlot,
        moduleBase + frameCodeRva
    )
    if not ok then
        return false, "frame-vtable install failed: " .. reason
    end
    frameDispatcherInstalled = true
    return true, string.format(
        "main-thread frame dispatch active code=0x%X "
            .. "vtable_slot=0x%X original=0x%X",
        frameCodeRva,
        frameVtableSlot,
        originalFramePointer
    )
end

local function ownHooksStillInstalled()
    return arraysEqual(
            safeReadArray(frameCodeRva, #FRAME_CODE_PREFIX),
            FRAME_CODE_PREFIX
        )
        and (
            not frameDispatcherInstalled
            or safeReadLong(frameVtableSlot, true)
                == moduleBase + frameCodeRva
        )
end

-- =========================================================================
-- WAKKA IDENTIFICATION
-- =========================================================================

local function lowercaseAsciiByte(value)
    if value >= 65 and value <= 90 then
        return value + 32
    end
    return value
end

local function isLetterOrDigit(value)
    value = lowercaseAsciiByte(value)
    return (value >= 97 and value <= 122)
        or (value >= 48 and value <= 57)
end

local function extractModelCode(bytes)
    if bytes == nil or #bytes < 10 then
        return nil
    end
    for index = 1, #bytes - 9 do
        local b1 = lowercaseAsciiByte(bytes[index] or 0)
        local b2 = lowercaseAsciiByte(bytes[index + 1] or 0)
        local b3 = bytes[index + 2] or 0
        local b4 = lowercaseAsciiByte(bytes[index + 3] or 0)
        local b5 = lowercaseAsciiByte(bytes[index + 4] or 0)
        local b6 = bytes[index + 5] or 0
        local b7 = bytes[index + 6] or 0
        local b8 = bytes[index + 7] or 0
        local b9 = bytes[index + 8] or 0
        local b10 = bytes[index + 9] or 0
        if b1 == 120 and b2 == 97 and b3 == 95
            and isLetterOrDigit(b4) and isLetterOrDigit(b5)
            and b6 == 95
            and b7 >= 48 and b7 <= 57
            and b8 >= 48 and b8 <= 57
            and b9 >= 48 and b9 <= 57
            and b10 >= 48 and b10 <= 57
        then
            return string.char(
                b1, b2, b3, b4, b5, b6, b7, b8, b9, b10
            )
        end
    end
    return nil
end

local function readMobjIdentityAt(mobj, pointerSource)
    if not plausibleRuntimeAddress(mobj)
        or safeReadInt(mobj, true) ~= MOBJ_MAGIC
    then
        return nil
    end
    local dataSize = safeReadInt(mobj + MOBJ_DATA_SIZE_OFFSET, true)
    local textureInfoSize =
        safeReadInt(mobj + MOBJ_TEXTURE_INFO_SIZE_OFFSET, true)
    local textureDataSize =
        safeReadInt(mobj + MOBJ_TEXTURE_DATA_SIZE_OFFSET, true)
    local modelSize = safeReadInt(mobj + MOBJ_MODEL_SIZE_OFFSET, true)
    local modelEncoded =
        safeReadInt(mobj + MOBJ_MODEL_POINTER_OFFSET, true)
    if dataSize == nil
        or textureInfoSize == nil
        or textureDataSize == nil
        or modelSize == nil
        or modelEncoded == nil
        or dataSize < 0x100
        or dataSize > 0x2000000
    then
        return nil
    end
    local model = resolveCompressedPointer(modelEncoded)
    if not plausibleRuntimeAddress(model) then
        return nil
    end
    local jointCount =
        safeReadInt(model + MODEL_JOINT_COUNT_OFFSET, true)
    local meshCount =
        safeReadInt(model + MODEL_MESH_COUNT_OFFSET, true)
    if jointCount == nil
        or meshCount == nil
        or jointCount < 1
        or jointCount > 4096
        or meshCount < 1
        or meshCount > 1024
    then
        return nil
    end
    return {
        mobj = mobj,
        model = model,
        fingerprint = string.format(
            "%08X:%08X:%08X:%08X:%04X:%04X",
            dataSize,
            textureInfoSize,
            textureDataSize,
            modelSize,
            jointCount,
            meshCount
        ),
        pointerSource = pointerSource or "unknown",
    }
end

local function readMobjIdentity(object)
    local encoded = safeReadInt(
        object + ENTITY_MOBJ_POINTER_OFFSET,
        true
    )
    if encoded ~= nil and encoded ~= 0 then
        local identity = readMobjIdentityAt(
            resolveCompressedPointer(encoded),
            "object+0x154"
        )
        if identity ~= nil then
            return identity
        end
    end

    local objectBytes = safeReadArray(object, 0x400, true)
    if objectBytes == nil then
        return nil
    end
    local references = {}
    local seen = {}
    local function addReference(address, source)
        if not plausibleRuntimeAddress(address) then
            return
        end
        local key = addressKey(address)
        if seen[key] then
            return
        end
        seen[key] = true
        references[#references + 1] = {
            address = address,
            source = source,
        }
    end

    for offset = 0, #objectBytes - 4, 4 do
        local value32 = bytesU32(objectBytes, offset + 1)
        if value32 >= 0x80000000 then
            addReference(
                resolveCompressedPointer(value32),
                string.format("object+0x%03X(compressed)", offset)
            )
        end
        if offset % 8 == 0 and offset <= #objectBytes - 8 then
            addReference(
                bytesU64(objectBytes, offset + 1),
                string.format("object+0x%03X(direct64)", offset)
            )
        end
    end
    for _, reference in ipairs(references) do
        local identity = readMobjIdentityAt(
            reference.address,
            reference.source
        )
        if identity ~= nil then
            return identity
        end
    end
    return nil
end

local function findModelCode(object, mobjIdentity)
    local objectBytes = safeReadArray(object, 0x400, true)
    local code = extractModelCode(objectBytes)
    if code ~= nil then
        return code
    end
    if mobjIdentity ~= nil then
        code = extractModelCode(
            safeReadArray(mobjIdentity.mobj, 0x100, true)
        )
        if code ~= nil then
            return code
        end
        code = extractModelCode(
            safeReadArray(mobjIdentity.mobj - 0x100, 0x200, true)
        )
        if code ~= nil then
            return code
        end
    end
    if objectBytes == nil then
        return nil
    end

    local references = {}
    local seen = {}
    local function addReference(address)
        if not plausibleRuntimeAddress(address) then
            return
        end
        local key = addressKey(address)
        if seen[key] then
            return
        end
        seen[key] = true
        references[#references + 1] = address
    end
    for offset = 0, #objectBytes - 4, 4 do
        local value32 = bytesU32(objectBytes, offset + 1)
        if value32 >= 0x80000000 then
            addReference(resolveCompressedPointer(value32))
        end
        if offset % 8 == 0 and offset <= #objectBytes - 8 then
            addReference(bytesU64(objectBytes, offset + 1))
        end
        if #references >= MAX_MODEL_REFERENCE_PROBES then
            break
        end
    end
    for index = 1, math.min(
        #references,
        MAX_MODEL_REFERENCE_PROBES
    ) do
        code = extractModelCode(
            safeReadArray(references[index], 0xA0, true)
        )
        if code ~= nil then
            return code
        end
    end
    return nil
end

local function markWakkaPresent(source, object, hp, maxHp, modelCode)
    wakkaLastSeenTick = tick
    wakkaMatchSource = source
    if not wakkaEncounterLatched then
        wakkaEncounterLatched = true
        activeSwitchAttempted = false
        addTimeline(string.format(
            "WAKKA ENCOUNTER LATCHED tick=%u seconds=%.3f",
            tick,
            tick / 60
        ), true)
    end
    if not wakkaPresent then
        wakkaPresent = true
        addTimeline(string.format(
            "WAKKA PRESENT tick=%u seconds=%.3f source=%s "
                .. "model=%s object=0x%X HP=%u/%u",
            tick,
            tick / 60,
            source,
            modelCode or "none",
            object,
            hp,
            maxHp
        ), true)
    end
end

local function examineEntity(object, source)
    if not plausibleRuntimeAddress(object) or object == currentSora then
        return
    end
    if safeReadByte(WORLD_ADDRESS) ~= SETTINGS.WAKKA_WORLD
        or safeReadByte(ROOM_ADDRESS) ~= SETTINGS.WAKKA_ROOM
    then
        return
    end
    local encodedStatPage = safeReadInt(
        object + ENTITY_STAT_PAGE_OFFSET,
        true
    )
    if encodedStatPage == nil or encodedStatPage == 0 then
        return
    end
    local statPage = resolveCompressedPointer(encodedStatPage)
    if not plausibleRuntimeAddress(statPage) then
        return
    end
    local hp = safeReadInt(statPage + STAT_CURRENT_HP_OFFSET, true)
    local maxHp = safeReadInt(statPage + STAT_MAX_HP_OFFSET, true)
    if hp == nil
        or maxHp == nil
        or hp == 0
        or maxHp == 0
        or hp > maxHp
        or maxHp > MAX_HP_STORAGE_VALUE
    then
        return
    end

    local identity = readMobjIdentity(object)
    local modelCode = findModelCode(object, identity)
    if modelCode ~= nil and SETTINGS.WAKKA_MODEL_CODES[modelCode] then
        markWakkaPresent(
            "model_code:" .. modelCode .. " via " .. source,
            object,
            hp,
            maxHp,
            modelCode
        )
        return
    end

    -- This second route accepts only native Wakka (75), the manager's current
    -- global 4x result (300), or Wakka's exact verification value (500).
    -- The projectile's 18/72 values therefore cannot arm the BGM redirect.
    if identity ~= nil
        and identity.fingerprint == SETTINGS.WAKKA_FINGERPRINT
        and (
            maxHp == SETTINGS.WAKKA_NATIVE_MAX_HP
            or maxHp == SETTINGS.WAKKA_GLOBAL_4X_MAX_HP
            or maxHp == SETTINGS.WAKKA_MANAGER_TEST_MAX_HP
        )
    then
        markWakkaPresent(
            "HP+fingerprint:" .. identity.fingerprint
                .. " via " .. source,
            object,
            hp,
            maxHp,
            modelCode
        )
    end
end

local function enqueueNode(address, depth, source)
    if not plausibleRuntimeAddress(address)
        or graphNodesQueued >= MAX_GRAPH_NODES
    then
        return
    end
    local key = addressKey(address)
    if graphQueued[key] or graphScanned[key] then
        return
    end
    graphQueued[key] = true
    graphNodesQueued = graphNodesQueued + 1
    graphQueue[#graphQueue + 1] = {
        address = address,
        depth = depth or 0,
        source = source or "unknown",
    }
end

local function considerReference(address, depth, source)
    if not plausibleRuntimeAddress(address) then
        return
    end
    examineEntity(address, source)
    enqueueNode(address, depth, source)
end

local function scanNode(node)
    examineEntity(node.address, node.source)
    if node.depth >= 2 then
        return
    end
    local scanLength = node.depth == 0 and 0x800 or 0x300
    local bytes = safeReadArray(node.address, scanLength, true)
    if bytes == nil then
        return
    end
    for offset = 0, scanLength - 4, 4 do
        local fieldSource = string.format(
            "0x%X+0x%03X",
            node.address,
            offset
        )
        local value32 = bytesU32(bytes, offset + 1)
        if value32 >= 0x80000000 then
            considerReference(
                resolveCompressedPointer(value32),
                node.depth + 1,
                fieldSource .. "(compressed)"
            )
        elseif plausibleRuntimeAddress(value32) then
            considerReference(
                value32,
                node.depth + 1,
                fieldSource .. "(raw32)"
            )
        end
        if offset % 8 == 0 and offset <= scanLength - 8 then
            local value64 = bytesU64(bytes, offset + 1)
            if plausibleRuntimeAddress(value64) then
                considerReference(
                    value64,
                    node.depth + 1,
                    fieldSource .. "(direct64)"
                )
            end
        end
    end
end

function SETTINGS._seedGraph()
    if currentSora ~= 0 then
        enqueueNode(currentSora, 0, "Sora root")
    end
    local nativeSora = safeReadLong(NATIVE_RAGNAROK_SORA_POINTER)
    if nativeSora ~= nil and nativeSora ~= 0 then
        enqueueNode(nativeSora, 0, "native-Sora root")
    end
end

function SETTINGS._restartGraph()
    graphQueue = {}
    graphQueueHead = 1
    graphQueued = {}
    graphScanned = {}
    graphNodesQueued = 0
    lastGraphRestartTick = tick
    SETTINGS._seedGraph()
end

function SETTINGS._processGraph()
    local processed = 0
    while processed < GRAPH_NODES_PER_TICK
        and graphQueueHead <= #graphQueue
    do
        local node = graphQueue[graphQueueHead]
        graphQueueHead = graphQueueHead + 1
        local key = addressKey(node.address)
        graphQueued[key] = nil
        if not graphScanned[key] then
            graphScanned[key] = true
            scanNode(node)
            processed = processed + 1
        end
    end
    if graphQueueHead > #graphQueue
        and tick - lastGraphRestartTick >= GRAPH_RESCAN_INTERVAL_TICKS
    then
        SETTINGS._restartGraph()
    end
end

function SETTINGS._processNarrowTargets()
    if currentSora ~= 0 then
        local encoded = safeReadInt(
            currentSora + SORA_LOCK_ON_TARGET_OFFSET,
            true
        )
        if encoded ~= nil and encoded ~= 0 then
            examineEntity(
                resolveCompressedPointer(encoded),
                "Sora+0x74"
            )
        end
    end

    local globalDirect = safeReadLong(LOCK_ON_TARGET_POINTER)
    if globalDirect ~= nil then
        examineEntity(globalDirect, "lock-on global direct")
    end
    local globalEncoded = safeReadInt(LOCK_ON_TARGET_POINTER)
    if globalEncoded ~= nil and globalEncoded >= 0x80000000 then
        examineEntity(
            resolveCompressedPointer(globalEncoded),
            "lock-on global compressed"
        )
    end

    for _ = 1, TARGET_GLOBAL_SLOTS_PER_TICK do
        local address = TARGET_GLOBAL_SCAN_START + globalScanOffset
        local direct = safeReadLong(address)
        if direct ~= nil then
            examineEntity(
                direct,
                string.format("module+0x%X direct", address)
            )
        end
        local encoded = safeReadInt(address)
        if encoded ~= nil and encoded >= 0x80000000 then
            examineEntity(
                resolveCompressedPointer(encoded),
                string.format("module+0x%X compressed", address)
            )
        end
        globalScanOffset = globalScanOffset + 4
        if globalScanOffset >= TARGET_GLOBAL_SCAN_LENGTH then
            globalScanOffset = 0
        end
    end
end

function SETTINGS._queueAlreadyPlayingSwitch()
    if activeSwitchAttempted
        or activeSwitchQueued
        or totalActiveSwitches > 0
    then
        return
    end

    local fields = {
        {
            offset = DATA_DISPATCH_VOLUME_BITS_OFFSET,
            value = primaryVolumeBits,
            name = "volume",
        },
        {
            offset = DATA_DISPATCH_FADE_BITS_OFFSET,
            value = primaryFadeBits,
            name = "fade volume",
        },
        {
            offset = DATA_DISPATCH_TIME_OFFSET,
            value = primaryTime,
            name = "time",
        },
    }
    for _, field in ipairs(fields) do
        local ok, reason = writeIntChecked(
            dataRva + field.offset,
            field.value
        )
        if not ok then
            enabled = false
            addStatus(
                "DISABLED: active-switch " .. field.name
                    .. " write failed: " .. tostring(reason) .. ".",
                true
            )
            saveReport()
            return
        end
    end

    local ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_STATUS_OFFSET,
        0
    )
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: active-switch status reset failed: "
                .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_COMMAND_OFFSET,
        1
    )
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: active-switch request write failed: "
                .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end
    activeSwitchAttempted = true
    activeSwitchQueued = true
    addTimeline(string.format(
        "NATIVE BUFFER ALLOCATION QUEUED tick=%u seconds=%.3f slot=%d "
            .. "source=%s replacement=%s volume=%s "
            .. "fade_volume=%s time=%d size=%u",
        tick,
        tick / 60,
        SETTINGS.PRIMARY_BGM_ID,
        SETTINGS.SOURCE_BGM,
        SETTINGS.REPLACEMENT_BGM,
        formatFloat(floatFromBits(primaryVolumeBits)),
        formatFloat(floatFromBits(primaryFadeBits)),
        signed32(primaryTime),
        SETTINGS.PRIVATE_SCD_SIZE
    ), true)
end

function SETTINGS._clearEncounterLatch(reason)
    if not wakkaEncounterLatched then
        return
    end
    wakkaEncounterLatched = false
    activeSwitchAttempted = false
    activeSwitchQueued = false
    writeIntChecked(dataRva + DATA_DISPATCH_COMMAND_OFFSET, 0)
    addTimeline(string.format(
        "WAKKA ENCOUNTER LATCH CLEARED tick=%u seconds=%.3f reason=%s",
        tick,
        tick / 60,
        reason
    ), true)
end

function SETTINGS._updatePresenceAndRoute()
    local inContext =
        safeReadByte(WORLD_ADDRESS) == SETTINGS.WAKKA_WORLD
        and safeReadByte(ROOM_ADDRESS) == SETTINGS.WAKKA_ROOM
    if wakkaEncounterLatched and not inContext then
        SETTINGS._clearEncounterLatch("left verified world/room")
    end

    local recentEvidence =
        tick - wakkaLastSeenTick <= SETTINGS.PRESENCE_HOLD_TICKS
    local shouldBePresent = inContext
        and (wakkaEncounterLatched or recentEvidence)

    if wakkaPresent and not shouldBePresent then
        wakkaPresent = false
        addTimeline(string.format(
            "WAKKA ABSENT tick=%u seconds=%.3f reason=%s",
            tick,
            tick / 60,
            inContext
                and "evidence timeout without active encounter latch"
                or "left verified world/room"
        ), true)
    end

    local desiredFlag = shouldBePresent and 1 or 0
    if desiredFlag ~= redirectFlagPublished then
        redirectFlagPublished = desiredFlag
        addTimeline(string.format(
            "ROUTE %s tick=%u enemy=Wakka source=%s replacement=%s",
            desiredFlag == 1 and "ARMED" or "DISARMED",
            tick,
            SETTINGS.SOURCE_BGM,
            SETTINGS.REPLACEMENT_BGM
        ), desiredFlag == 1)
    end
    if desiredFlag == 1 and enabled then
        SETTINGS._queueAlreadyPlayingSwitch()
    end
end

-- =========================================================================
-- PRIVATE SCD COPY AND ON-DEMAND BGM DISPATCH RESULT
-- =========================================================================

function SETTINGS._failPrivateScdCopy(reason)
    if SETTINGS._copyFile ~= nil then
        pcall(function()
            SETTINGS._copyFile:close()
        end)
        SETTINGS._copyFile = nil
    end
    writeIntChecked(dataRva + DATA_DISPATCH_STATUS_OFFSET, 8)
    activeSwitchQueued = false
    enabled = false
    addTimeline(string.format(
        "PRIVATE SCD COPY FAILED tick=%u seconds=%.3f "
            .. "offset=%u reason=%s",
        tick,
        tick / 60,
        SETTINGS._copyOffset or 0,
        tostring(reason)
    ), true)
    saveReport()
end

function SETTINGS._processPrivateScdTransfer()
    if SETTINGS._frameStage ~= "allocation" then
        return
    end
    local status =
        safeReadByte(dataRva + DATA_DISPATCH_STATUS_OFFSET) or 0
    if status ~= 2 then
        return
    end

    local buffer = safeReadLong(dataRva + DATA_LOAD_BUFFER_OFFSET) or 0
    if not plausibleRuntimeAddress(buffer) then
        SETTINGS._failPrivateScdCopy(
            "allocator reported an invalid native buffer"
        )
        return
    end

    if SETTINGS._copyFile == nil then
        SETTINGS._copyFile = io.open(SETTINGS.PRIVATE_SCD_PATH, "rb")
        SETTINGS._copyOffset = 0
        if SETTINGS._copyFile == nil then
            SETTINGS._failPrivateScdCopy(
                "private SCD could not be reopened"
            )
            return
        end
        addTimeline(string.format(
            "NATIVE BUFFER READY tick=%u seconds=%.3f "
                .. "size=%u buffer=0x%X",
            tick,
            tick / 60,
            SETTINGS.PRIVATE_SCD_SIZE,
            buffer
        ), true)
    end

    local remaining =
        SETTINGS.PRIVATE_SCD_SIZE - SETTINGS._copyOffset
    if remaining <= 0 then
        SETTINGS._failPrivateScdCopy(
            "copy offset exceeded the private SCD size"
        )
        return
    end
    local wanted = math.min(SETTINGS.COPY_CHUNK_SIZE, remaining)
    local chunk = SETTINGS._copyFile:read(wanted)
    if chunk == nil or string.len(chunk) ~= wanted then
        SETTINGS._failPrivateScdCopy("private SCD read was incomplete")
        return
    end

    local bytes = {}
    for index = 1, wanted do
        bytes[index] = string.byte(chunk, index)
    end
    local ok, reason = writeArrayAbsoluteChecked(
        buffer + SETTINGS._copyOffset,
        bytes
    )
    if not ok then
        SETTINGS._failPrivateScdCopy(reason)
        return
    end

    SETTINGS._copyOffset = SETTINGS._copyOffset + wanted
    ok, reason = writeIntChecked(
        dataRva + DATA_COPY_PROGRESS_OFFSET,
        SETTINGS._copyOffset
    )
    if not ok then
        SETTINGS._failPrivateScdCopy(reason)
        return
    end
    reportDirty = true
    if SETTINGS._copyOffset < SETTINGS.PRIVATE_SCD_SIZE then
        return
    end

    local extra = SETTINGS._copyFile:read(1)
    SETTINGS._copyFile:close()
    SETTINGS._copyFile = nil
    if extra ~= nil then
        SETTINGS._failPrivateScdCopy(
            "private SCD changed size during the copy"
        )
        return
    end
    local nativeMagic = safeReadArray(buffer, 8, true)
    local expectedMagic = {
        0x53, 0x45, 0x44, 0x42, 0x53, 0x53, 0x43, 0x46,
    }
    if not arraysEqual(nativeMagic, expectedMagic) then
        SETTINGS._failPrivateScdCopy(
            "native buffer header did not verify"
        )
        return
    end

    ok, reason = SETTINGS._installRegisterStage()
    if not ok then
        SETTINGS._failPrivateScdCopy(reason)
        return
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_STATUS_OFFSET,
        0
    )
    if not ok then
        SETTINGS._failPrivateScdCopy(reason)
        return
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_COMMAND_OFFSET,
        2
    )
    if not ok then
        SETTINGS._failPrivateScdCopy(reason)
        return
    end
    addTimeline(string.format(
        "PRIVATE SCD COPY VERIFIED tick=%u seconds=%.3f "
            .. "bytes=%u; REGISTRATION QUEUED slot=%u",
        tick,
        tick / 60,
        SETTINGS._copyOffset,
        SETTINGS.PRIMARY_BGM_ID
    ), true)
end

function SETTINGS._processDispatchCounter()
    local status =
        safeReadByte(dataRva + DATA_DISPATCH_STATUS_OFFSET) or 0
    lastLoadSize = unsigned32(
        safeReadInt(dataRva + DATA_LOAD_SIZE_OFFSET) or 0
    )
    lastLoadBuffer =
        safeReadLong(dataRva + DATA_LOAD_BUFFER_OFFSET) or 0
    lastTargetResource = unsigned32(
        safeReadInt(dataRva + DATA_TARGET_RESOURCE_OFFSET) or 0
    )
    if status ~= lastDispatchStatus then
        lastDispatchStatus = status
        if status == 1 then
            addTimeline(string.format(
                "NATIVE BUFFER ALLOCATION ENTERED tick=%u seconds=%.3f",
                tick,
                tick / 60
            ), false)
        elseif status == 2 then
            addTimeline(string.format(
                "NATIVE BUFFER ALLOCATED tick=%u seconds=%.3f "
                    .. "size=%u buffer=0x%X",
                tick,
                tick / 60,
                lastLoadSize,
                lastLoadBuffer
            ), false)
        elseif status == 4 then
            addTimeline(string.format(
                "BGM REGISTRATION ENTERED tick=%u seconds=%.3f",
                tick,
                tick / 60
            ), false)
        elseif status == 3 or status == 5
            or status == 6 or status == 8
        then
            local reasons = {
                [3] = "native aligned-buffer allocation failed",
                [5] = "file-manager singleton unavailable",
                [6] = "live BGM resource registration failed",
                [8] = "Lua disk read or native-buffer copy failed",
            }
            activeSwitchQueued = false
            addTimeline(string.format(
                "ACTIVE SWITCH FAILED tick=%u seconds=%.3f "
                    .. "status=%u reason=%s load_size=%u buffer=0x%X",
                tick,
                tick / 60,
                status,
                reasons[status],
                lastLoadSize,
                lastLoadBuffer
            ), true)
        elseif status == 7 then
            addTimeline(string.format(
                "PRIVATE BGM RESOURCE READY tick=%u seconds=%.3f "
                    .. "name=%s slot=%u size=%u buffer=0x%X "
                    .. "resource=0x%08X",
                tick,
                tick / 60,
                SETTINGS.REPLACEMENT_BGM,
                SETTINGS.PRIMARY_BGM_ID,
                lastLoadSize,
                lastLoadBuffer,
                lastTargetResource
            ), true)
        end
    end

    local current =
        safeReadInt(dataRva + DATA_DISPATCH_COUNTER_OFFSET)
    if current == nil or current == lastDispatchCounter then
        return
    end
    local delta = counterDelta(current, lastDispatchCounter)
    lastDispatchCounter = current
    totalActiveSwitches = totalActiveSwitches + delta
    activeSwitchQueued = false
    addTimeline(string.format(
        "ACTIVE SWITCH EXECUTED tick=%u seconds=%.3f count=%u total=%u",
        tick,
        tick / 60,
        delta,
        totalActiveSwitches
    ), true)
end

-- =========================================================================
-- PUBLIC CALLBACKS
-- =========================================================================

function SETTINGS._preparePrivateScdPath()
    if SCRIPT_PATH == nil or io == nil or io.open == nil then
        return false, "Lua script path or file access is unavailable"
    end
    local separator = string.sub(SCRIPT_PATH, -1) == "\\" and "" or "\\"
    SETTINGS.PRIVATE_SCD_PATH =
        SCRIPT_PATH .. separator .. SETTINGS.PRIVATE_SCD_FILENAME
    local privateFile = io.open(SETTINGS.PRIVATE_SCD_PATH, "rb")
    if privateFile == nil then
        return false, "private SCD was not found: "
            .. SETTINGS.PRIVATE_SCD_PATH
    end
    local privateMagic = privateFile:read(8)
    local privateSize = privateFile:seek("end")
    privateFile:close()
    if privateMagic ~= "SEDBSSCF" then
        return false, "private SCD header is invalid"
    end
    if type(privateSize) ~= "number"
        or privateSize < 0x100
        or privateSize > 0x7FFFFFFF
        or privateSize ~= math.floor(privateSize)
    then
        return false, "private SCD size is invalid"
    end
    SETTINGS.PRIVATE_SCD_SIZE = privateSize
    return true
end

function SETTINGS._resetPrivateThemeState()
    if SETTINGS._copyFile ~= nil then
        pcall(function()
            SETTINGS._copyFile:close()
        end)
    end
    SETTINGS._copyFile = nil
    SETTINGS._copyOffset = 0
    SETTINGS._frameStage = "none"
    SETTINGS.PRIVATE_SCD_SIZE = nil
    enabled = false
    tick = 0
    sections = {}
    sizeOfImage = 0
    moduleBase = tonumber(BASE_ADDR) or 0
    codeRva = 0
    frameCodeRva = 0
    dataRva = 0
    frameVtableSlot = 0
    originalFramePointer = 0
    frameDispatcherInstalled = false

    currentSora = 0
    wakkaLastSeenTick = -100000
    wakkaPresent = false
    wakkaMatchSource = nil
    redirectFlagPublished = -1
    wakkaEncounterLatched = false
    activeSwitchQueued = false
    activeSwitchAttempted = false
    graphQueue = {}
    graphQueueHead = 1
    graphQueued = {}
    graphScanned = {}
    graphNodesQueued = 0
    lastGraphRestartTick = -100000
    globalScanOffset = 0

    lastDispatchCounter = 0
    lastDispatchStatus = 0
    lastLoadSize = 0
    lastLoadBuffer = 0
    lastTargetResource = 0
    totalActiveSwitches = 0
    timelineRows = {}
    timelineCapped = false
    statusLines = {}
    primaryVolumeBits = 0x3F400000
    primaryFadeBits = 0x3F400000
    primaryTime = 0
    reportDirty = true
    lastReportSaveTick = 0
end

function _OnInit()
    SETTINGS._resetPrivateThemeState()
    addStatus(
        "Route: Wakka present -> "
            .. SETTINGS.SOURCE_BGM .. " becomes "
            .. SETTINGS.REPLACEMENT_BGM .. ".",
        false
    )
    addStatus(
        "Safety: the reused 18-HP projectile fingerprint cannot arm the route.",
        false
    )
    addStatus(
        "Late detection: an already-playing source is switched on the next "
            .. "main-game frame; the confirmed encounter then remains latched.",
        false
    )

    if not SETTINGS.ENABLE then
        addStatus("DISABLED: SETTINGS.ENABLE is false.", true)
        saveReport()
        return
    end
    local pathOK, pathReason = SETTINGS._preparePrivateScdPath()
    if not pathOK then
        addStatus("DISABLED: " .. pathReason .. ".", true)
        saveReport()
        return
    end
    if not plausibleRuntimeAddress(moduleBase) then
        addStatus("DISABLED: LuaBackend BASE_ADDR is invalid.", true)
        saveReport()
        return
    end
    if string.len(SETTINGS.SOURCE_BGM) >= 0x20
        or string.len(SETTINGS.REPLACEMENT_BGM) >= 0x20
        or string.match(
            SETTINGS.SOURCE_BGM,
            "^music%d%d%d%.win32%.scd$"
        ) == nil
        or string.match(
            SETTINGS.REPLACEMENT_BGM,
            "^music%d%d%d%.win32%.scd$"
        ) == nil
        or string.sub(SETTINGS.SOURCE_BGM, 1, 8)
            == string.sub(SETTINGS.REPLACEMENT_BGM, 1, 8)
    then
        addStatus("DISABLED: BGM names are invalid or too long.", true)
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(
            POINTER_RESOLVER_RVA,
            #POINTER_RESOLVER_SIGNATURE
        ),
        POINTER_RESOLVER_SIGNATURE
    ) then
        addStatus(
            "DISABLED: Steam Global executable signature mismatch.",
            true
        )
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(BGM_FUNCTION_RVA, #BGM_FUNCTION_SIGNATURE),
        BGM_FUNCTION_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified BGM function signature mismatch.",
            true
        )
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(
            BGM_STOP_FUNCTION_RVA,
            #BGM_STOP_FUNCTION_SIGNATURE
        ),
        BGM_STOP_FUNCTION_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified BGM stop-function signature mismatch.",
            true
        )
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(
            FILE_MANAGER_LOCK_RVA,
            #FILE_MANAGER_LOCK_SIGNATURE
        ),
        FILE_MANAGER_LOCK_SIGNATURE
    ) or not arraysEqual(
        safeReadArray(
            FILE_MANAGER_UNLOCK_RVA,
            #FILE_MANAGER_UNLOCK_SIGNATURE
        ),
        FILE_MANAGER_UNLOCK_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified file-manager lock signature mismatch.",
            true
        )
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(
            ALIGNED_MALLOC_CALL_RVA,
            #ALIGNED_MALLOC_CALL_SIGNATURE
        ),
        ALIGNED_MALLOC_CALL_SIGNATURE
    ) or not arraysEqual(
        safeReadArray(
            ALIGNED_FREE_CALL_RVA,
            #ALIGNED_FREE_CALL_SIGNATURE
        ),
        ALIGNED_FREE_CALL_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified aligned allocator call sites mismatch.",
            true
        )
        saveReport()
        return
    end
    if not plausibleRuntimeAddress(
        safeReadLong(ALIGNED_MALLOC_IAT_RVA)
    ) or not plausibleRuntimeAddress(
        safeReadLong(ALIGNED_FREE_IAT_RVA)
    ) then
        addStatus(
            "DISABLED: aligned allocator imports are unavailable.",
            true
        )
        saveReport()
        return
    end
    if not arraysEqual(
        safeReadArray(
            REGISTER_BGM_RESOURCE_RVA,
            #REGISTER_BGM_RESOURCE_SIGNATURE
        ),
        REGISTER_BGM_RESOURCE_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified BGM resource-registration signature mismatch.",
            true
        )
        saveReport()
        return
    end
    local peOK, peReason = parsePeImage()
    if not peOK then
        addStatus("DISABLED: " .. peReason .. ".", true)
        saveReport()
        return
    end

    local hookOK, hookReason = installHooks()
    if not hookOK then
        addStatus("DISABLED: " .. hookReason .. ".", true)
        saveReport()
        return
    end

    pcall(SetHertz, 60)
    currentSora = safeReadLong(SORA_POINTER) or 0
    SETTINGS._restartGraph()
    lastDispatchCounter =
        safeReadInt(dataRva + DATA_DISPATCH_COUNTER_OFFSET) or 0
    lastDispatchStatus =
        safeReadByte(dataRva + DATA_DISPATCH_STATUS_OFFSET) or 0
    enabled = true
    SETTINGS._updatePresenceAndRoute()

    addStatus("READY: " .. hookReason .. ".", true)
    addStatus(
        "READY: private Wakka SCD verified at "
            .. tostring(SETTINGS.PRIVATE_SCD_SIZE)
            .. " bytes; original menu music110 remains untouched.",
        true
    )
    addStatus(
        "Fight Wakka once. F2 should show WAKKA PRESENT, ROUTE ARMED, "
            .. "NATIVE BUFFER READY, PRIVATE SCD COPY VERIFIED, then "
            .. "ACTIVE SWITCH EXECUTED on slot 1. Use a full game restart "
            .. "instead of F1 while testing this vtable-dispatch version.",
        true
    )
    saveReport()
end

function _OnFrame()
    if not enabled then
        return
    end
    tick = tick + 1

    if not frameDispatcherInstalled then
        local frameOK, frameReason = activateFrameDispatcher()
        if not frameOK then
            enabled = false
            addStatus(
                "DISABLED: could not activate main-thread dispatch: "
                    .. tostring(frameReason) .. ".",
                true
            )
            saveReport()
            return
        end
        addStatus("READY: " .. frameReason .. ".", true)
    end

    if tick % 120 == 0 and not ownHooksStillInstalled() then
        enabled = false
        addStatus(
            "DISABLED: another script replaced the Wakka frame dispatch.",
            true
        )
        saveReport()
        return
    end

    local sora = safeReadLong(SORA_POINTER) or 0
    if sora ~= currentSora then
        currentSora = sora
        globalScanOffset = 0
        SETTINGS._restartGraph()
    end

    SETTINGS._processNarrowTargets()
    SETTINGS._processGraph()
    SETTINGS._updatePresenceAndRoute()
    if not enabled then
        return
    end
    SETTINGS._processDispatchCounter()
    SETTINGS._processPrivateScdTransfer()

    if reportDirty
        and tick - lastReportSaveTick
            >= SETTINGS.REPORT_SAVE_INTERVAL_TICKS
    then
        saveReport()
    end
end
