-- Kingdom Hearts Final Mix (Steam Global)
-- File: KHFM_EnemyConfig.lua
-- Single-file enemy HP, speed, and multi-private-theme controller v4.4.7.
--
-- Verified component bases:
--   Enemy Stats Manager v2.6
--   Multi-Enemy Battle Themes v1.1 / Wakka v2.8 native route
--   KINGDOM HEARTS FINAL MIX.exe Steam Global 1.0.0.2 family
--   SHA-256 d790746245d26159f3ee0e1060e33b2fa2de06941850a4ac724f598722884bac
--   LuaBackendHook v1.9.1-hook / LuaEngine v5.0
--
-- This is the only Lua file required by this package. Remove every older
-- EnemyConfig, Enemy Stats Manager, Multi-Enemy Battle Themes, BGM recorder,
-- and Wakka private-theme loader before installing it. The private SCD is a
-- binary audio asset and remains beside this Lua after OpenKH builds the mod.
--
-- The two proven native hook implementations remain isolated internally.
-- A shared object+stat-page exclusion registry runs before either subsystem,
-- preventing Wakka's 18-HP projectile from being multiplied and later accepted
-- as an unmapped music target.

LUAGUI_NAME = "KHFM Enemy Config"
LUAGUI_AUTH = "OpenAI"
LUAGUI_DESC = "Per-enemy HP, speed, and private battle themes without native music replacement"

-- ========================= USER SETTINGS =========================
-- Edit the enemy rows below. nil means "leave unchanged."
--
-- MAX_HP          Exact HP amount.
-- ANIMATION_SPEED Per-animation animation + world-movement multipliers:
--                 { [animation ID] = speed }
-- OVERALL_SPEED   Animation + world-movement speed for all other animations.
--                 Avoid on projectile users.
-- BATTLE_THEME    Private .win32.scd filename beside this Lua.
--                 nil starts no new private theme. If another enemy's
--                 private theme is already playing, lock-on preserves it.
--
-- Wakka contains the verified example. Every named row is addressable.

local ENEMY_SETTINGS = {
    ["Shadow"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 2, BATTLE_THEME = nil },
    ["Soldier"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 1.2, BATTLE_THEME = nil },
    ["Powerwild"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 1.3, BATTLE_THEME = nil },
    ["Bouncywild"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 1.3, BATTLE_THEME = nil },
    ["Large Body"] = { 
        MAX_HP = 80, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Fat Bandit"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Sea Neon"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Sheltering Zone"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Aquatank"] = { 
        MAX_HP = 80, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Screwdiver"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Bandit"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Pirate"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Red Nocturne"] = {
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Blue Rhapsody"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Yellow Opera"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Green Requiem"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Wizard"] = { 
        MAX_HP = 80, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Air Soldier"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Pot Spider"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 2, BATTLE_THEME = nil },
    ["Barrel Spider"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = 2, BATTLE_THEME = nil },
    ["Pot Scorpion"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = 2, BATTLE_THEME = nil },
    ["Wight Knight"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Air Pirate"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Gargoyle"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Search Ghost"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Darkball"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Invisible"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Behemoth"] = { 
        MAX_HP = 3000, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Wyvern"] = { 
        MAX_HP = 200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Angel Star"] = { 
        MAX_HP = 80, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Defender"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["White Mushroom"] = { 
        MAX_HP = nil, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Black Fungus"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Rare Truffle"] = { 
        MAX_HP = 9999, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Pink Agaricus"] = {
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Neoshadow"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Stealth Soldier"] = { 
        MAX_HP = 200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Gigas Shadow"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Sniperwild"] = {
        MAX_HP = 200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Black Ballade"] = {
        MAX_HP = 80, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Grand Ghost"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Jet Balloon"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Missile Diver"] = { 
        MAX_HP = 100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Chimera"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Battleship"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Riku - Wooden Sword"] = {
        MAX_HP = 280,
        ANIMATION_SPEED = {},
        OVERALL_SPEED = 1.4,
        BATTLE_THEME = "KHFM_RowdyRumbleTheme.win32.scd", 
    },
    ["Tidus"] = {
        MAX_HP = 220,
        ANIMATION_SPEED = {},
        OVERALL_SPEED = 1.5,
        BATTLE_THEME = "KHFM_TidusTheme.win32.scd",
    },
    ["Selphie"] = { 
        MAX_HP = 180, 
        ANIMATION_SPEED = { [0x00] = 2.00, [0x01] = 1.60, [0x02] = 1.60, [0xED] = 1.60, [0xEE] = 2.00, [0xEF] = 2.00, [0xF0] = 2.00, [0xF1] = 1.00, [0xF2] = 1.50, [0xF4] = 1.50, [0xF5] = 1.50, [0xF6] = 2.00, [0xF7] = 1.00, [0xFB] = 1.00, [0xFD] = 1.00, }, 
        OVERALL_SPEED = nil,
        BATTLE_THEME = "KHFM_SelphieTheme.win32.scd", 
    },
    ["Wakka"] = {
        MAX_HP = 200,
        ANIMATION_SPEED = { [0x00] = 3.00, [0x01] = 3.00, [0x02] = 2.00, [0x06] = 4.00, [0x07] = 4.00, [0xEA] = 1.00, [0xEB] = 1.00, [0xE6] = 4.00, [0xE7] = 1.00, [0xE9] = 4.00, [0xF5] = 5.00, [0xF6] = 5.00, [0xF7] = 1.50 },
        OVERALL_SPEED = nil,
        BATTLE_THEME = "KHFM_WakkaTheme.win32.scd",
    },
    ["Darkside"] = { 
        MAX_HP = 900,
        ANIMATION_SPEED = { [0xDA] = 1.00 },
        OVERALL_SPEED = 1.2,
        BATTLE_THEME = "KHFM_DarksideTheme.win32.scd",
    },
    ["Leon"] = {
        MAX_HP = 999,
        ANIMATION_SPEED = { [0xD0] = 1.00, [0x00] = 3.00, [0x01] = 3.00, [0x07] = 1.00, [0x49] = 1.00, [0xCA] = 1.40, [0xCB] = 1.40, [0xCC] = 1.40, [0xD7] = 2.00, [0xD8] = 2.00, },
        OVERALL_SPEED = 1.2,
        BATTLE_THEME = "KHFM_LeonTheme.win32.scd",
    },
    ["Guard Armor"] = { 
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Opposite Armor"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Trickmaster"] = { 
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Queen's Spade Cards"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Queen's Heart Cards"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Cloud"] = { 
        MAX_HP = 1500,
        ANIMATION_SPEED = {}, 
        OVERALL_SPEED = nil, 
        BATTLE_THEME = "KHFM_CloudTheme.win32.scd", 
    },
    ["Hercules"] = { 
        MAX_HP = nil, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Cerberus"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Hades"] = { 
        MAX_HP = 1500, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Rock Titan"] = { 
        MAX_HP = 4000, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Ice Titan"] = { 
        MAX_HP = 4000, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Sephiroth"] = { 
        MAX_HP = 7777, 
        ANIMATION_SPEED = {}, 
        OVERALL_SPEED = nil, 
        BATTLE_THEME = "KHFM_SephirothTheme.win32.scd",
    },
    ["Sabor"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Clayton"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Stealth Sneak"] = { 
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Jafar"] = { 
        MAX_HP = 600, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Genie Jafar"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Pot Centipede"] = { 
        MAX_HP = 600, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Kurt Zisa"] = {
        MAX_HP = 1800, 
        ANIMATION_SPEED = {}, 
        OVERALL_SPEED = nil,
        BATTLE_THEME = nil 
    },
    ["Cave of Wonders Guardian"] = { 
        MAX_HP = 600, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Parasite Cage"] = { 
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Ursula"] = {
        MAX_HP = 600, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Giant Ursula"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Flotsam and Jetsam"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Atlantica Shark"] = { 
        MAX_HP = 300, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Lock"] = { 
        MAX_HP = 10, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Shock"] = { 
        MAX_HP = 10, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Barrel"] = { 
        MAX_HP = 10, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Oogie Boogie"] = { 
        MAX_HP = 600, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Oogie's Manor"] = { 
        MAX_HP = 1, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Captain Hook"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Phantom"] = { 
        MAX_HP = 1800, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["AntiSora"] = { 
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Maleficent"] = {
        MAX_HP = 900, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Maleficent Dragon"] = { 
        MAX_HP = 1500, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Riku - Soul Eater"] = { 
        MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Riku-Ansem"] = { 
       MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Dark Riku"] = { 
       MAX_HP = 1200, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Chernabog"] = { 
       MAX_HP = 1800, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Ansem with Guardian"] = { 
       MAX_HP = 2100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Bit Sniper"] = { 
       MAX_HP = nil, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["World of Chaos"] = {
       MAX_HP = 2700, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Ansem - Final Boss"] = { 
       MAX_HP = 2100, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = "KHFM_AnsemShipTheme.win32.scd", },
    ["Xemnas - Enigmatic Man"] = { 
       MAX_HP = 9999, ANIMATION_SPEED = {}, OVERALL_SPEED = nil, BATTLE_THEME = nil },
    ["Yuffie"] = {
       MAX_HP = 999,
       ANIMATION_SPEED = {},
       OVERALL_SPEED = nil,
       BATTLE_THEME = nil
    },
}

-- ======================= END USER SETTINGS =======================
-- Everything below is internal. No changes are needed.

local INTERNAL_CONFIG = {
    ENABLE = true,

    STATS_DEFAULTS = {
        MAX_HP = nil,
        HP_MULTIPLIER = 1.00,
        DAMAGE_TAKEN_MULTIPLIER = 1.00,
        DAMAGE_DEALT_MULTIPLIER = 1.00,
        PRESERVE_CURRENT_HP_RATIO = true,
    },

    UNKNOWN_ENEMY_STATS = {
        enabled = false,
        hp_multiplier = nil,
        max_hp = nil,
        damage_taken_multiplier = nil,
        speed_multiplier = nil,
        overall_speed_multiplier = nil,
        animation_speed_multipliers = {},
        safe_speed_animations = {},
    },
    ENABLE_UNKNOWN_ENEMY_STATS = false,

    EXPERIMENTAL_ANIMATION_SPEED = {
        ENABLE = true,
        GLOBAL_MULTIPLIER = 1.00,
        ALLOW_CONFIRMED_TARGET_FALLBACK = false,
        LOG_OBSERVED_ANIMATIONS = true,
        SCALE_WORLD_MOVEMENT = true,
        -- Enemy actor transforms keep synchronized X/Z positions at these
        -- three verified offsets. The same extra displacement is added to
        -- each copy so collision, rendering, and the actor root remain in
        -- agreement.
        POSITION_VECTOR_OFFSETS = { 0x10, 0x50, 0x100 },
        -- Larger one-frame movement is treated as a warp/scene correction and
        -- becomes a new baseline instead of being multiplied.
        MAX_HORIZONTAL_DELTA_PER_TICK = 250.0,
    },

    MUSIC_DEFAULTS = {
        enabled = false,
        replacement_bgm = "music110.win32.scd",
        source_bgm = nil,
        bgm_slot = nil,
        priority = 10,
    },

    UNKNOWN_ENEMY_MUSIC = {
        enabled = false,
        replacement_bgm = "music110.win32.scd",
        source_bgm = nil,
        bgm_slot = nil,
        priority = 1,
    },

    -- These are confirmed non-enemy lock-on targets. The object+stat-page key
    -- is remembered before either subsystem can modify or route it. The 72-HP
    -- value covers the exact v2.6 compatibility failure where another copy of
    -- the 4x stats manager had already changed Wakka's native 18-HP projectile.
    NON_ENEMY_EXCLUSIONS = {
        {
            label = "Wakka 18-HP projectile",
            world = 1,
            room = 0,
            max_hp_values = { 18, 72 },
            fingerprint =
                "000745F8:00000070:0001C000:0004B000:009A:0007",
        },

    },

    PRESENCE_HOLD_TICKS = 180,
    PRIVATE_THEME_FADE_OUT_MS = 1500,
    AUTO_SLOT1_BONUS_TICKS = 180,
    AUTO_SOURCE_WAIT_TICKS = 90,
    AUTO_SOURCE_PRE_ROLL_TICKS = 300,
    MAX_TRACKED_BGM_SLOT = 3,

    LOG_IDENTIFIED_ENEMIES = true,
    LOG_UNRESOLVED_MODELS = true,
    ECHO_ALL_BGM_TO_F2 = true,
    REPORT_SAVE_INTERVAL_TICKS = 60,
    MAX_TIMELINE_ROWS = 20000,
    STATS_REPORT_FILENAME =
        "KH1FM_All_Enemy_Stats_Speed_Themes_v2_2_Stats_Report.txt",
    MUSIC_REPORT_FILENAME =
        "KH1FM_All_Enemy_Stats_Speed_Themes_v2_Music_Report.txt",

    ENEMIES = {
        -- ================================================================
        -- REGULAR HEARTLESS
        -- ================================================================
        ["Shadow"] = {
            model_codes = { "xa_ex_2020", "xa_ex_2021", "xa_ex_2022", "xa_ex_2029" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 5, native_max_hp = 12,
                    max_hp_values = { 12 },
                    fingerprint =
                        "00022FF8:00000030:0000C000:00016370:0054:0003",
                },
},
        },
        ["Soldier"] = {
            model_codes = { "xa_ex_2010", "xa_ex_2019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Powerwild"] = {
            model_codes = { "xa_ex_2030", "xa_ex_2039" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Bouncywild"] = {
            model_codes = { "xa_ex_2040", "xa_ex_2049" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Large Body"] = {
            model_codes = { "xa_ex_2050", "xa_ex_2059" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Fat Bandit"] = {
            model_codes = { "xa_ex_2060", "xa_ex_2069" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Sea Neon"] = {
            model_codes = { "xa_ex_2070", "xa_ex_2079" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Sheltering Zone"] = {
            model_codes = { "xa_ex_2080", "xa_ex_2089" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Aquatank"] = {
            model_codes = { "xa_ex_2240", "xa_ex_2249" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Screwdiver"] = {
            model_codes = { "xa_ex_2250", "xa_ex_2259" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Bandit"] = {
            model_codes = { "xa_ex_2090", "xa_ex_2099" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Pirate"] = {
            model_codes = { "xa_ex_2100", "xa_ex_2109" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Red Nocturne"] = {
            model_codes = { "xa_ex_2110", "xa_ex_2119" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Blue Rhapsody"] = {
            model_codes = { "xa_ex_2120", "xa_ex_2129" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Yellow Opera"] = {
            model_codes = { "xa_ex_2130", "xa_ex_2139" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Green Requiem"] = {
            model_codes = { "xa_ex_2140", "xa_ex_2149" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Wizard"] = {
            model_codes = { "xa_ex_2150", "xa_ex_2151", "xa_ex_2159" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Air Soldier"] = {
            model_codes = { "xa_ex_2160", "xa_ex_2169" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Pot Spider"] = {
            model_codes = { "xa_ex_2170", "xa_ex_2172", "xa_ex_2179" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Barrel Spider"] = {
            model_codes = { "xa_ex_2180", "xa_ex_2182", "xa_ex_2184", "xa_ex_2189" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Pot Scorpion"] = {
            model_codes = { "xa_ex_2190", "xa_ex_2199" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Wight Knight"] = {
            model_codes = { "xa_ex_2200", "xa_ex_2201", "xa_ex_2209" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Air Pirate"] = {
            model_codes = { "xa_ex_2210", "xa_ex_2219" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Gargoyle"] = {
            model_codes = { "xa_ex_2220", "xa_ex_2221", "xa_ex_2229" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Search Ghost"] = {
            model_codes = { "xa_ex_2230", "xa_ex_2231", "xa_ex_2238", "xa_ex_2239" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Darkball"] = {
            model_codes = { "xa_ex_2280", "xa_ex_2281", "xa_ex_2282", "xa_ex_2289" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Invisible"] = {
            model_codes = { "xa_ex_2290", "xa_ex_2292", "xa_ex_2299" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Behemoth"] = {
            model_codes = {
                "xa_ex_2310", "xa_ex_2311", "xa_ex_2312",
                "xa_ex_2317", "xa_ex_2318", "xa_ex_2319",
            },
            fingerprints = {},
            context_bindings = {},
        },
        ["Wyvern"] = {
            model_codes = { "xa_ex_2320", "xa_ex_2329" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Angel Star"] = {
            model_codes = { "xa_ex_2330", "xa_ex_2339" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Defender"] = {
            model_codes = { "xa_ex_2340" },
            fingerprints = {},
            context_bindings = {},
        },
        ["White Mushroom"] = {
            model_codes = { "xa_ex_2349", "xa_ex_2350", "xa_ex_2352", "xa_ex_2359" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Black Fungus"] = {
            model_codes = { "xa_ex_2380", "xa_ex_2381", "xa_ex_2389" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Rare Truffle"] = {
            model_codes = { "xa_ex_2390", "xa_ex_2391", "xa_ex_2399" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- FINAL MIX SPECIAL HEARTLESS
        -- ================================================================
        ["Pink Agaricus"] = {
            model_codes = { "xa_ex_2410", "xa_ex_2419" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Neoshadow"] = {
            model_codes = { "xa_ex_2420", "xa_ex_2429" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Stealth Soldier"] = {
            model_codes = { "xa_ex_2430", "xa_ex_2439" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Gigas Shadow"] = {
            model_codes = { "xa_ex_2440", "xa_ex_2449" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Sniperwild"] = {
            model_codes = { "xa_ex_2450", "xa_ex_2459" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Black Ballade"] = {
            model_codes = { "xa_ex_2460", "xa_ex_2469" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Grand Ghost"] = {
            model_codes = { "xa_ex_2470", "xa_ex_2479" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Jet Balloon"] = {
            model_codes = { "xa_ex_2480", "xa_ex_2489" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Missile Diver"] = {
            model_codes = { "xa_ex_2490" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Chimera"] = {
            model_codes = { "xa_ex_2260", "xa_ex_2269" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Battleship"] = {
            model_codes = { "xa_ex_2270", "xa_ex_2279" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- DESTINY ISLANDS / TRAVERSE TOWN / WONDERLAND
        -- ================================================================
        ["Riku - Wooden Sword"] = {
            source_bgm = "music119.win32.scd",
            bgm_slot = 1, music_priority = 100,
            model_codes = { "xa_ex_1010", "xa_ex_1011", "xa_ex_1019" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 0, native_max_hp = 90,
                    max_hp_values = { 90 },
                    fingerprint =
                        "0007A8F8:00000070:0001C000:0004E450:00E3:0007",
                },
},
        },
        ["Tidus"] = {
            source_bgm = "music119.win32.scd",
            bgm_slot = 1, music_priority = 100,
            model_codes = { "xa_di_1010", "xa_di_1019" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 0, native_max_hp = 60,
                    max_hp_values = { 60 },
                    fingerprint =
                        "00075B78:00000070:0001C000:0004D690:00B9:0008",
                },
},
        },
        ["Selphie"] = {
            source_bgm = "music119.win32.scd",
            bgm_slot = 1, music_priority = 100,
            model_codes = { "xa_di_1020", "xa_di_1029" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 0, native_max_hp = 45,
                    max_hp_values = { 45 },
                    fingerprint =
                        "0007B378:00000060:00018000:00055430:00C8:000A",
                },
            },
        },
        ["Wakka"] = {
            source_bgm = "music119.win32.scd",
            bgm_slot = 1, music_priority = 100,
            model_codes = { "xa_di_1030", "xa_di_1039" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 0, native_max_hp = 75,
                    max_hp_values = { 75 },
                    fingerprint =
                        "000745F8:00000070:0001C000:0004B000:009A:0007",
                },
            },
        },
        ["Darkside"] = {
            source_bgm = "music145.win32.scd",
            bgm_slot = 0, music_priority = 100,
            model_codes = { "xa_di_3000", "xa_di_3001", "xa_di_3009" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 1, room = 8, native_max_hp = 300,
                    max_hp_values = { 300 },
                    fingerprint =
                        "0007DC78:000000A0:00028000:000533A0:00E6:000A",
                },
},
        },
        ["Leon"] = {
            source_bgm = "music131.win32.scd",
            bgm_slot = 1, music_priority = 100,
            model_codes = { "xa_ex_1030", "xa_ex_1031", "xa_ex_1038", "xa_ex_1039" },
            fingerprints = {},
            context_bindings = {
                {
                    world = 3, room = 0, native_max_hp = 120,
                    max_hp_values = { 120 },
                    fingerprint =
                        "00092CF8:000000A0:00028000:0005ABF0:00F7:000D",
                },
},
        },
        ["Guard Armor"] = {
            model_codes = { "xa_tw_3000", "xa_tw_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Opposite Armor"] = {
            model_codes = { "xa_tw_3010", "xa_tw_3019", "xa_tw_3020", "xa_tw_3029" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Trickmaster"] = {
            model_codes = { "xa_aw_3000", "xa_aw_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Queen's Spade Cards"] = {
            model_codes = { "xa_aw_1030", "xa_aw_1031", "xa_aw_1039" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Queen's Heart Cards"] = {
            model_codes = { "xa_aw_1060", "xa_aw_1061", "xa_aw_1069" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- OLYMPUS COLISEUM
        -- ================================================================
        ["Cloud"] = {
            model_codes = { "xa_ex_1150", "xa_ex_1151", "xa_ex_1159" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Hercules"] = {
            model_codes = { "xa_ex_4010", "xa_ex_4011", "xa_ex_4019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Cerberus"] = {
            model_codes = { "xa_he_3020", "xa_he_3021", "xa_he_3029" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Hades"] = {
            model_codes = { "xa_he_1010", "xa_he_1011", "xa_he_1019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Rock Titan"] = {
            model_codes = { "xa_he_3000", "xa_he_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Ice Titan"] = {
            model_codes = { "xa_he_3010", "xa_he_3019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Sephiroth"] = {
            model_codes = { "xa_ex_3000", "xa_ex_3008", "xa_ex_3009" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- DEEP JUNGLE / AGRABAH
        -- ================================================================
        ["Sabor"] = {
            model_codes = { "xa_tz_3000", "xa_tz_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Clayton"] = {
            model_codes = { "xa_tz_3010", "xa_tz_3011", "xa_tz_3019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Stealth Sneak"] = {
            model_codes = {
                "xa_tz_3020", "xa_tz_3029", "xa_tz_3040", "xa_tz_3049",
            },
            fingerprints = {},
            context_bindings = {},
        },
        ["Jafar"] = {
            model_codes = { "xa_al_3010", "xa_al_3018", "xa_al_3019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Genie Jafar"] = {
            model_codes = { "xa_al_3020", "xa_al_3029" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Pot Centipede"] = {
            model_codes = { "xa_al_3030", "xa_al_3040", "xa_ex_2400" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Kurt Zisa"] = {
            model_codes = { "xa_al_3050", "xa_al_3059" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Cave of Wonders Guardian"] = {
            model_codes = { "xa_al_3060" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- MONSTRO / ATLANTICA
        -- ================================================================
        ["Parasite Cage"] = {
            model_codes = { "xa_pi_3000", "xa_pi_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Ursula"] = {
            model_codes = { "xa_lm_1050", "xa_lm_1059" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Giant Ursula"] = {
            model_codes = { "xa_lm_3000", "xa_lm_3040" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Flotsam and Jetsam"] = {
            model_codes = { "xa_lm_3010", "xa_lm_3020", "xa_lm_3029" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Atlantica Shark"] = {
            model_codes = { "xa_lm_3030" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- HALLOWEEN TOWN / NEVERLAND
        -- ================================================================
        ["Lock"] = {
            model_codes = { "xa_nm_1030", "xa_nm_1031", "xa_nm_1038", "xa_nm_1039" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Shock"] = {
            model_codes = { "xa_nm_1040", "xa_nm_1041", "xa_nm_1048", "xa_nm_1049" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Barrel"] = {
            model_codes = { "xa_nm_1050", "xa_nm_1051", "xa_nm_1058", "xa_nm_1059" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Oogie Boogie"] = {
            model_codes = { "xa_nm_3000", "xa_nm_3008", "xa_nm_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Oogie's Manor"] = {
            model_codes = { "xa_nm_3010", "xa_nm_3020", "xa_nm_3030" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Captain Hook"] = {
            model_codes = { "xa_pp_3000", "xa_pp_3001", "xa_pp_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Phantom"] = {
            model_codes = { "xa_pp_3010", "xa_pp_3019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["AntiSora"] = {
            model_codes = { "xa_pp_3020", "xa_pp_3030" },
            fingerprints = {},
            context_bindings = {},
        },

        -- ================================================================
        -- HOLLOW BASTION / END OF THE WORLD / SUPERBOSSES
        -- ================================================================
        ["Maleficent"] = {
            model_codes = { "xa_ex_1090", "xa_ex_1091", "xa_ex_1099" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Maleficent Dragon"] = {
            model_codes = { "xa_pc_3000", "xa_pc_3009" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Riku - Soul Eater"] = {
            model_codes = { "xa_ex_1560", "xa_ex_1568" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Riku-Ansem"] = {
            model_codes = { "xa_ex_1580", "xa_ex_1588", "xa_ex_1589" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Dark Riku"] = {
            model_codes = { "xa_ex_1160", "xa_ex_1168" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Chernabog"] = {
            model_codes = { "xa_pc_3020" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Ansem with Guardian"] = {
            model_codes = { "xa_ex_1630", "xa_ex_1638", "xa_ex_1639" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Bit Sniper"] = {
            model_codes = { "xa_ew_2010" },
            fingerprints = {},
            context_bindings = {},
        },
        ["World of Chaos"] = {
            model_codes = {
                "xa_ew_2020", "xa_ew_2030", "xa_ew_2040", "xa_ew_2050",
            },
            fingerprints = {},
            context_bindings = {},
        },
        ["Ansem - Final Boss"] = {
            model_codes = { "xa_ew_3020" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Xemnas - Enigmatic Man"] = {
            model_codes = { "xa_ex_3010", "xa_ex_3018", "xa_ex_3019" },
            fingerprints = {},
            context_bindings = {},
        },
        ["Yuffie"] = {
            model_codes = { "xa_ex_1040", "xa_ex_1041", "xa_ex_1048", "xa_ex_1049" },
            fingerprints = {},
            context_bindings = {},
        },
    },

    -- Shared private state. Do not edit these two fields.
    _excludedTargets = {},
    _excludedStatsLogged = {},
}

-- Compile the compact user table into the verified internal profile format.
-- This block also fails early if a named row is missing or misspelled.
do
    local function battleThemeName(value)
        if value == nil or value == false then
            return nil
        end
        if type(value) == "number"
            and value >= 0 and value <= 999
            and value == math.floor(value)
        then
            return string.format("music%03d.win32.scd", value)
        end
        if type(value) == "string" then
            local numeric = tonumber(value)
            if numeric ~= nil
                and numeric >= 0 and numeric <= 999
                and numeric == math.floor(numeric)
            then
                return string.format("music%03d.win32.scd", numeric)
            end
            return value
        end
        return value
    end

    local settingsCount = 0
    for name, edit in pairs(ENEMY_SETTINGS) do
        settingsCount = settingsCount + 1
        if INTERNAL_CONFIG.ENEMIES[name] == nil then
            error("ENEMY_SETTINGS contains unknown row: " .. tostring(name))
        end
        if type(edit) ~= "table" then
            error(tostring(name) .. " settings row is not a table")
        end
        if type(edit.ANIMATION_SPEED) ~= "table" then
            error(tostring(name) .. ".ANIMATION_SPEED must be a table")
        end
        if edit.BATTLE_THEME ~= nil then
            if type(edit.BATTLE_THEME) ~= "string"
                or string.match(edit.BATTLE_THEME, "%.win32%.scd$") == nil
            then
                error(tostring(name)
                    .. ".BATTLE_THEME must be nil or a .win32.scd filename")
            end
        end
    end

    -- A fingerprint describes the enemy's MOBJ/model structure and remains
    -- stable when another instance of that enemy appears in a different room.
    -- Promote every non-conflicting fingerprint learned from a context binding
    -- into the row's global fingerprint list. Context remains a fallback for
    -- rows whose fingerprint is unknown or ambiguous.
    local fingerprintOwners = {}
    local function claimFingerprint(fingerprint, enemyName)
        if type(fingerprint) ~= "string" or fingerprint == "" then
            return
        end
        local existing = fingerprintOwners[fingerprint]
        if existing == nil then
            fingerprintOwners[fingerprint] = enemyName
        elseif existing ~= enemyName then
            fingerprintOwners[fingerprint] = false
        end
    end
    for name, row in pairs(INTERNAL_CONFIG.ENEMIES) do
        for _, fingerprint in ipairs(row.fingerprints or {}) do
            claimFingerprint(fingerprint, name)
        end
        for _, binding in ipairs(row.context_bindings or {}) do
            claimFingerprint(binding.fingerprint, name)
        end
    end
    INTERNAL_CONFIG.UNIQUE_FINGERPRINT_COUNT = 0
    for fingerprint, owner in pairs(fingerprintOwners) do
        if owner ~= false then
            local row = INTERNAL_CONFIG.ENEMIES[owner]
            local present = false
            for _, existing in ipairs(row.fingerprints or {}) do
                if existing == fingerprint then
                    present = true
                    break
                end
            end
            if not present then
                row.fingerprints[#row.fingerprints + 1] = fingerprint
            end
            INTERNAL_CONFIG.UNIQUE_FINGERPRINT_COUNT =
                INTERNAL_CONFIG.UNIQUE_FINGERPRINT_COUNT + 1
        end
    end

    local profileCount = 0
    for name, row in pairs(INTERNAL_CONFIG.ENEMIES) do
        profileCount = profileCount + 1
        local edit = ENEMY_SETTINGS[name]
        if edit == nil then
            error("ENEMY_SETTINGS is missing row: " .. tostring(name))
        end

        row.hp_multiplier = nil
        row.max_hp = edit.MAX_HP
        row.damage_taken_multiplier = 1.00
        row.speed_multiplier = nil
        row.overall_speed_multiplier = edit.OVERALL_SPEED
        row.animation_speed_multipliers = edit.ANIMATION_SPEED
        row.safe_speed_animations = {}
        for animationId in pairs(edit.ANIMATION_SPEED) do
            row.safe_speed_animations[
                #row.safe_speed_animations + 1
            ] = animationId
        end
        row.stats_enabled = edit.MAX_HP ~= nil
            or edit.OVERALL_SPEED ~= nil
            or next(edit.ANIMATION_SPEED) ~= nil

        row.replacement_bgm = battleThemeName(edit.BATTLE_THEME)
        row.music_enabled = row.replacement_bgm ~= nil
        if row.bgm_slot ~= nil
            and (
                type(row.bgm_slot) ~= "number"
                or row.bgm_slot < 0
                or row.bgm_slot > INTERNAL_CONFIG.MAX_TRACKED_BGM_SLOT
                or row.bgm_slot ~= math.floor(row.bgm_slot)
            )
        then
            error(tostring(name) .. ".bgm_slot must be nil or an integer "
                .. "from 0 through "
                .. tostring(INTERNAL_CONFIG.MAX_TRACKED_BGM_SLOT))
        end

        for _, binding in ipairs(row.context_bindings or {}) do
            binding.max_hp_values = binding.max_hp_values
                or { binding.native_max_hp }
            if edit.MAX_HP ~= nil then
                binding.max_hp_values[
                    #binding.max_hp_values + 1
                ] = edit.MAX_HP
            end
        end
    end

    if settingsCount ~= profileCount or profileCount ~= 96 then
        error(string.format(
            "enemy table count mismatch: settings=%d profiles=%d expected=96",
            settingsCount,
            profileCount
        ))
    end
end

local function buildStatsModule(SHARED)
    local SETTINGS = {
        ENABLE = SHARED.ENABLE,
        GLOBAL = SHARED.STATS_DEFAULTS,
        ENABLE_CONFIRMED_TARGET_FALLBACK =
            SHARED.ENABLE_UNKNOWN_ENEMY_STATS,
        CONFIRMED_TARGET_FALLBACK = SHARED.UNKNOWN_ENEMY_STATS,
        FINGERPRINT_PROFILE_BINDINGS = {},
        TARGET_CONTEXT_PROFILE_BINDINGS = {},
        EXPERIMENTAL_ANIMATION_SPEED =
            SHARED.EXPERIMENTAL_ANIMATION_SPEED,
        NON_ENEMY_EXCLUSIONS = SHARED.NON_ENEMY_EXCLUSIONS,
        LOG_IDENTIFIED_ENEMIES = SHARED.LOG_IDENTIFIED_ENEMIES,
        LOG_UNRESOLVED_MODELS = SHARED.LOG_UNRESOLVED_MODELS,
        REPORT_FILENAME = SHARED.STATS_REPORT_FILENAME,
        ENEMIES = {},
    }

    for name, row in pairs(SHARED.ENEMIES) do
        local profile = {}
        for key, value in pairs(row) do
            profile[key] = value
        end
        profile.enabled = row.stats_enabled ~= false
        SETTINGS.ENEMIES[name] = profile

        for _, binding in ipairs(row.context_bindings or {}) do
            SETTINGS.TARGET_CONTEXT_PROFILE_BINDINGS[
                #SETTINGS.TARGET_CONTEXT_PROFILE_BINDINGS + 1
            ] = {
                enemy = name,
                world = binding.world,
                room = binding.room,
                native_max_hp = binding.native_max_hp,
                fingerprint = binding.fingerprint,
            }
        end
    end

-- =========================================================================
-- VERIFIED STEAM GLOBAL MEMORY LAYOUT
-- =========================================================================

local SORA_POINTER = 0x2537E48
local LOCK_ON_TARGET_POINTER = 0x25387F0
local POINTER_BANK_TABLE = 0x2EE3980
local NATIVE_RAGNAROK_SORA_POINTER = 0x2D37280
local ROOM_ADDRESS = 0x233FE8C
local WORLD_ADDRESS = 0x233FE94

local SORA_LOCK_ON_TARGET_OFFSET = 0x74
local ENTITY_STAT_PAGE_OFFSET = 0x6C
local ENTITY_MOBJ_POINTER_OFFSET = 0x154
local ENTITY_ACTION_ID_OFFSET = 0x70
local ENTITY_CURRENT_ANIMATION_OFFSET = 0x164
local ENTITY_RESOLVED_MOTION_INDEX_OFFSET = 0x168
local ENTITY_ANIMATION_TIME_OFFSET = 0x16C
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

local POINTER_RESOLVER_RVA = 0x38ADC0
local POINTER_RESOLVER_SIGNATURE = {
    0x85, 0xC9, 0x75, 0x03, 0x33, 0xC0,
    0xC3, 0xE9, 0x74, 0x01, 0x00, 0x00,
}

local FINAL_HP_ADJUST_RVA = 0x2A4920
local FINAL_HP_ADJUST_SIGNATURE = {
    0x48, 0x89, 0x74, 0x24, 0x10,
    0x48, 0x89, 0x7C, 0x24, 0x18,
    0x41, 0x56, 0x48, 0x83, 0xEC, 0x20,
}

local HOOK_CALLSITE_RVA = 0x2A4930
local HOOK_CALLSITE_ORIGINAL = {
    0x48, 0x8B, 0xF1, 0x44, 0x8B, 0xF2,
}
local HOOK_CALLSITE_PATCH = {
    0xE8, 0x1B, 0xA8, 0x10, 0x00, 0x90,
}

local HOOK_CAVE_RVA = 0x3AF150
local HOOK_CAVE_SIZE = 0xB0
local HOOK_CODE_PREFIX_SIZE = 0x68
local HOOK_SORA_RVA = HOOK_CAVE_RVA + 0x68
local HOOK_DEFAULT_TAKEN_RVA = HOOK_CAVE_RVA + 0x70
local HOOK_DEFAULT_DEALT_RVA = HOOK_CAVE_RVA + 0x74
local HOOK_TARGET_TABLE_RVA = HOOK_CAVE_RVA + 0x78
local HOOK_TARGET_SLOT_SIZE = 8
local HOOK_TARGET_SLOT_COUNT = 4
local HOOK_LAST_DAMAGE_TARGET_RVA = HOOK_CAVE_RVA + 0x98
local V19_COMPATIBILITY_SINK_RVA = HOOK_CAVE_RVA + 0xA0

-- Legacy v1.1-v1.5 hook image. It is recognized only so v2 can replace it
-- safely when Lua scripts are reloaded without restarting the game.
local V1_5_HOOK_CAVE_BYTES = {
    0x48, 0x89, 0xCE, 0x41, 0x89, 0xD6, 0x45, 0x85,
    0xF6, 0x7D, 0x4F, 0x48, 0x3B, 0x0D, 0x4A, 0x00,
    0x00, 0x00, 0x74, 0x30, 0x8B, 0x41, 0x6C, 0x4C,
    0x8D, 0x05, 0x4E, 0x00, 0x00, 0x00, 0x41, 0xB9,
    0x06, 0x00, 0x00, 0x00, 0x41, 0x3B, 0x00, 0x74,
    0x13, 0x49, 0x83, 0xC0, 0x08, 0x41, 0xFF, 0xC9,
    0x75, 0xF2, 0xF3, 0x0F, 0x10, 0x0D, 0x2A, 0x00,
    0x00, 0x00, 0xEB, 0x10, 0xF3, 0x41, 0x0F, 0x10,
    0x48, 0x04, 0xEB, 0x08, 0xF3, 0x0F, 0x10, 0x0D,
    0x1C, 0x00, 0x00, 0x00, 0xF3, 0x41, 0x0F, 0x2A,
    0xC6, 0xF3, 0x0F, 0x59, 0xC1, 0xF3, 0x44, 0x0F,
    0x2C, 0xF0, 0xC3, 0x90,

    -- live Sora pointer
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    -- default target multiplier 1.0 and damage-to-Sora multiplier 1.0
    0x00, 0x00, 0x80, 0x3F, 0x00, 0x00, 0x80, 0x3F,

    -- six { encoded_stat_page, multiplier } target slots
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    -- alignment then v19 compatibility sink at +0xA0
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x80, 0x3F,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
}

-- 176-byte v2 hook image assembled for module+0x3AF150. In addition to
-- scaling signed HP deltas, it records the exact non-Sora object passed to
-- the native final-HP routine. Lua clears the capture after processing it.
local HOOK_CAVE_TEMPLATE = {
    0x48, 0x89, 0xCE, 0x41, 0x89, 0xD6, 0x45, 0x85,
    0xF6, 0x7D, 0x56, 0x48, 0x3B, 0x0D, 0x56, 0x00,
    0x00, 0x00, 0x74, 0x37, 0x48, 0x89, 0x0D, 0x7D,
    0x00, 0x00, 0x00, 0x8B, 0x41, 0x6C, 0x4C, 0x8D,
    0x05, 0x53, 0x00, 0x00, 0x00, 0x41, 0xB9, 0x04,
    0x00, 0x00, 0x00, 0x41, 0x3B, 0x00, 0x74, 0x13,
    0x49, 0x83, 0xC0, 0x08, 0x41, 0xFF, 0xC9, 0x75,
    0xF2, 0xF3, 0x0F, 0x10, 0x0D, 0x2F, 0x00, 0x00,
    0x00, 0xEB, 0x10, 0xF3, 0x41, 0x0F, 0x10, 0x48,
    0x04, 0xEB, 0x08, 0xF3, 0x0F, 0x10, 0x0D, 0x21,
    0x00, 0x00, 0x00, 0xF3, 0x41, 0x0F, 0x2A, 0xC6,
    0xF3, 0x0F, 0x59, 0xC1, 0xF3, 0x44, 0x0F, 0x2C,
    0xF0, 0xC3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    -- live Sora pointer
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    -- default target multiplier and damage-to-Sora multiplier
    0x00, 0x00, 0x80, 0x3F, 0x00, 0x00, 0x80, 0x3F,
    -- four { encoded_stat_page, multiplier } target slots
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    -- native last-damage target pointer
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    -- v19 compatibility sink at +0xA0
    0x00, 0x00, 0x80, 0x3F,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
}

local V19_HOOK_CAVE_BYTES = {
    0x48, 0x89, 0xCE, 0x41, 0x89, 0xD6, 0x45, 0x85,
    0xF6, 0x7D, 0x29, 0x48, 0x3B, 0x0D, 0xE6, 0x8C,
    0x18, 0x02, 0x74, 0x20, 0x66, 0x41, 0x0F, 0x6E,
    0xC6, 0x0F, 0x5B, 0xC0, 0xF3, 0x0F, 0x59, 0x05,
    0x7C, 0x00, 0x00, 0x00, 0xF3, 0x44, 0x0F, 0x2D,
    0xF0, 0x45, 0x85, 0xF6, 0x75, 0x06, 0x41, 0xBE,
    0xFF, 0xFF, 0xFF, 0xFF, 0xC3,
}

local TARGET_GLOBAL_SCAN_START = 0x2538000
local TARGET_GLOBAL_SCAN_LENGTH = 0x1000
local TARGET_GLOBAL_SLOTS_PER_TICK = 16

local GRAPH_RESCAN_INTERVAL_TICKS = 180
local GRAPH_NODES_PER_TICK = 4
local MAX_GRAPH_NODES = 1536
local MAX_ENTITY_CANDIDATES = 192
local MAX_MODEL_REFERENCE_PROBES = 64
local MAX_HP_STORAGE_VALUE = 2147483647
local MAX_MULTIPLIER = 10.00

-- Used only after the narrow Sora+0x74 route or native final-HP capture plus
-- lock-on corroboration proves that an otherwise-unmapped object is a target.
local CONFIRMED_TARGET_FALLBACK_PROFILE = {
    name = "Confirmed live target",
    enabled = SETTINGS.CONFIRMED_TARGET_FALLBACK.enabled ~= false,
    hp_multiplier = SETTINGS.CONFIRMED_TARGET_FALLBACK.hp_multiplier,
    max_hp = SETTINGS.CONFIRMED_TARGET_FALLBACK.max_hp,
    damage_taken_multiplier =
        SETTINGS.CONFIRMED_TARGET_FALLBACK.damage_taken_multiplier,
    speed_multiplier = SETTINGS.CONFIRMED_TARGET_FALLBACK.speed_multiplier,
    overall_speed_multiplier =
        SETTINGS.CONFIRMED_TARGET_FALLBACK.overall_speed_multiplier,
    animation_speed_multipliers =
        SETTINGS.CONFIRMED_TARGET_FALLBACK.animation_speed_multipliers or {},
    safe_speed_animations =
        SETTINGS.CONFIRMED_TARGET_FALLBACK.safe_speed_animations,
    model_codes = {},
    fingerprints = {},
    is_confirmed_target_fallback = true,
}

-- =========================================================================
-- RUNTIME STATE
-- =========================================================================

local enabled = false
local tick = 0
local currentSora = 0
local capturedDamageSequence = 0
local rejectedDamageEvents = {}
local lastPreHitTarget = 0

local reportLines = {}
local reportDirty = false
local lastReportSaveTick = 0

local modelCodeProfiles = {}
local fingerprintProfiles = {}
local targetContextProfileBindings = {}
local profileWarnings = {}

local graphQueue = {}
local graphQueueHead = 1
local graphQueued = {}
local graphScanned = {}
local graphNodesQueued = 0
local lastGraphRestartTick = -100000
local globalScanOffset = 0

local candidates = {}
local candidateOrder = {}
local candidateCount = 0
-- Kept across discovery resets. The key is the resolved stat-page address.
-- The engine can expose one stat page through several wrapper objects, so a
-- wrapper change alone must not turn an already-applied maximum into a new
-- native baseline.
local healthBaselines = {}
local unresolvedLogged = {}
local identifiedLogged = {}
local motionObservedLogged = {}
local lastOverflowCount = -1
local damageRouteLogKey = nil

-- =========================================================================
-- LOGGING
-- =========================================================================

local function log(message)
    ConsolePrint("[AllEnemyStatsSpeedThemesV2:Stats] " .. message)
end

local function appendReport(message)
    reportLines[#reportLines + 1] = message
    reportDirty = true
end

local function record(message, echo)
    appendReport(message)
    if echo then
        log(message)
    end
end

local function saveReport()
    if not reportDirty then
        return true
    end
    if io == nil or io.open == nil or SCRIPT_PATH == nil then
        return false
    end
    local file = io.open(
        SCRIPT_PATH .. "\\" .. SETTINGS.REPORT_FILENAME,
        "w"
    )
    if file == nil then
        return false
    end
    file:write(table.concat(reportLines, "\n"))
    file:write("\n")
    file:close()
    reportDirty = false
    lastReportSaveTick = tick
    return true
end

local function pointerText(value)
    return string.format("0x%X", value or 0)
end

local function addressKey(value)
    return string.format("%.0f", value or 0)
end

-- =========================================================================
-- SAFE MEMORY HELPERS
-- =========================================================================

local function unsigned32(value)
    if value == nil then
        return 0
    end
    if value < 0 then
        return value + 4294967296
    end
    return value
end

local function safeReadInt(address, absolute)
    local ok, value = pcall(ReadInt, address, absolute)
    if not ok or value == nil then
        return nil
    end
    return unsigned32(value)
end

local function safeReadByte(address, absolute)
    local ok, value = pcall(ReadByte, address, absolute)
    if not ok or value == nil then
        return nil
    end
    if value < 0 then
        return value + 256
    end
    return value
end

local function safeReadLong(address, absolute)
    local ok, value = pcall(ReadLong, address, absolute)
    if not ok or value == nil then
        return nil
    end
    return value
end

local function safeReadFloat(address, absolute)
    local ok, value = pcall(ReadFloat, address, absolute)
    if not ok or value == nil then
        return nil
    end
    return value
end

local function safeReadArray(address, length, absolute)
    local ok, value = pcall(ReadArray, address, length, absolute)
    if not ok or value == nil or #value < length then
        return nil
    end
    return value
end

local function safeWriteInt(address, value, absolute)
    local ok, reason = pcall(WriteInt, address, value, absolute)
    if not ok then
        return false, tostring(reason)
    end
    local readback = safeReadInt(address, absolute)
    if readback ~= unsigned32(value) then
        return false, "integer write did not verify"
    end
    return true
end

local function safeWriteFloat(address, value, absolute)
    local ok, reason = pcall(WriteFloat, address, value, absolute)
    if not ok then
        return false, tostring(reason)
    end
    local readback = safeReadFloat(address, absolute)
    if readback == nil or math.abs(readback - value) > 0.0001 then
        return false, "float write did not verify"
    end
    return true
end

local function safeWriteArray(address, bytes, absolute)
    local ok, reason = pcall(WriteArray, address, bytes, absolute)
    if not ok then
        return false, tostring(reason)
    end
    local readback = safeReadArray(address, #bytes, absolute)
    if readback == nil then
        return false, "array write could not be read back"
    end
    for index = 1, #bytes do
        if readback[index] ~= bytes[index] then
            return false, "array write did not verify"
        end
    end
    return true
end

local function arraysEqual(left, right, count)
    if left == nil or right == nil then
        return false
    end
    local length = count or #right
    if #left < length or #right < length then
        return false
    end
    for index = 1, length do
        if left[index] ~= right[index] then
            return false
        end
    end
    return true
end

local function isZeroArray(bytes)
    if bytes == nil then
        return false
    end
    for index = 1, #bytes do
        if bytes[index] ~= 0 then
            return false
        end
    end
    return true
end

local function pointerBytes(value)
    local bytes = {}
    local remaining = value or 0
    for index = 1, 8 do
        bytes[index] = remaining % 256
        remaining = math.floor(remaining / 256)
    end
    return bytes
end

local function safeWritePointer(address, value)
    return safeWriteArray(address, pointerBytes(value), false)
end

local function bytesU32(bytes, index)
    return (bytes[index] or 0)
        + (bytes[index + 1] or 0) * 256
        + (bytes[index + 2] or 0) * 65536
        + (bytes[index + 3] or 0) * 16777216
end

local function bytesU64(bytes, index)
    local low = bytesU32(bytes, index)
    local high = bytesU32(bytes, index + 4)
    return low + high * 4294967296
end

local function plausibleRuntimeAddress(address)
    return address ~= nil
        and address >= 0x10000
        and address < 0x0000800000000000
        and address % 4 == 0
end

local function resolveCompressedPointer(encoded)
    local value = unsigned32(encoded)
    if value == 0 then
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
-- SETTINGS VALIDATION AND LOOKUP TABLES
-- =========================================================================

local function validMultiplier(value)
    return type(value) == "number"
        and value > 0.0
        and value <= MAX_MULTIPLIER
end

local function validSpeedMultiplier(value)
    return type(value) == "number"
        and value >= 0.10
        and value <= 10.00
end

local function validExactMaximum(value)
    return value == nil
        or (
            type(value) == "number"
            and value >= 1
            and value <= MAX_HP_STORAGE_VALUE
            and value == math.floor(value)
        )
end

local function normalizeModelCode(value)
    if type(value) ~= "string" then
        return nil
    end
    return string.lower(value)
end

local function buildProfileLookups()
    modelCodeProfiles = {}
    fingerprintProfiles = {}
    targetContextProfileBindings = {}
    profileWarnings = {}

    if not validExactMaximum(SETTINGS.GLOBAL.MAX_HP) then
        return false,
            "GLOBAL.MAX_HP must be nil or a number from 1 through 2147483647"
    end
    if not validMultiplier(SETTINGS.GLOBAL.HP_MULTIPLIER)
        or not validMultiplier(SETTINGS.GLOBAL.DAMAGE_TAKEN_MULTIPLIER)
        or not validMultiplier(SETTINGS.GLOBAL.DAMAGE_DEALT_MULTIPLIER)
    then
        return false, "global multipliers must be above 0 and no greater than 10"
    end
    if type(SETTINGS.EXPERIMENTAL_ANIMATION_SPEED) ~= "table"
        or not validSpeedMultiplier(
            SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.GLOBAL_MULTIPLIER
        )
    then
        return false, "experimental global speed must be from 0.10 through 10.00"
    end
    if type(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .ALLOW_CONFIRMED_TARGET_FALLBACK
    ) ~= "boolean" then
        return false,
            "ALLOW_CONFIRMED_TARGET_FALLBACK must be true or false"
    end
    if type(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.SCALE_WORLD_MOVEMENT
    ) ~= "boolean" then
        return false, "SCALE_WORLD_MOVEMENT must be true or false"
    end
    if type(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.POSITION_VECTOR_OFFSETS
    ) ~= "table"
        or #SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .POSITION_VECTOR_OFFSETS == 0
    then
        return false, "POSITION_VECTOR_OFFSETS must not be empty"
    end
    for _, offset in ipairs(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.POSITION_VECTOR_OFFSETS
    ) do
        if type(offset) ~= "number"
            or offset < 0
            or offset ~= math.floor(offset)
        then
            return false,
                "POSITION_VECTOR_OFFSETS contains an invalid offset"
        end
    end
    if type(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .MAX_HORIZONTAL_DELTA_PER_TICK
    ) ~= "number"
        or SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .MAX_HORIZONTAL_DELTA_PER_TICK <= 0
    then
        return false,
            "MAX_HORIZONTAL_DELTA_PER_TICK must be greater than zero"
    end

    local fallback = SETTINGS.CONFIRMED_TARGET_FALLBACK
    if type(fallback) ~= "table" then
        return false, "CONFIRMED_TARGET_FALLBACK is not a table"
    end
    if fallback.hp_multiplier ~= nil
        and not validMultiplier(fallback.hp_multiplier)
    then
        return false, "fallback hp_multiplier must be above 0 and no greater than 10"
    end
    if not validExactMaximum(fallback.max_hp) then
        return false, "fallback max_hp is invalid"
    end
    if fallback.damage_taken_multiplier ~= nil
        and not validMultiplier(fallback.damage_taken_multiplier)
    then
        return false,
            "fallback damage_taken_multiplier must be above 0 and no greater than 10"
    end
    if fallback.speed_multiplier ~= nil
        and not validSpeedMultiplier(fallback.speed_multiplier)
    then
        return false, "fallback speed_multiplier must be from 0.10 through 10.00"
    end
    if type(fallback.safe_speed_animations) ~= "table" then
        return false, "fallback safe_speed_animations is not a table"
    end
    CONFIRMED_TARGET_FALLBACK_PROFILE.safeSpeedAnimationSet = {}
    for _, animationId in ipairs(fallback.safe_speed_animations) do
        if type(animationId) ~= "number"
            or animationId < 0
            or animationId > 255
            or animationId ~= math.floor(animationId)
        then
            return false,
                "fallback safe_speed_animations contains an invalid ID"
        end
        CONFIRMED_TARGET_FALLBACK_PROFILE.safeSpeedAnimationSet[
            animationId
        ] = true
    end

    for name, profile in pairs(SETTINGS.ENEMIES) do
        if type(profile) ~= "table" then
            return false, "enemy row " .. tostring(name) .. " is not a table"
        end

        if profile.hp_multiplier ~= nil
            and not validMultiplier(profile.hp_multiplier)
        then
            return false, name
                .. ".hp_multiplier must be above 0 and no greater than 10"
        end

        if not validExactMaximum(profile.max_hp) then
            return false, name .. ".max_hp is invalid"
        end

        if profile.damage_taken_multiplier ~= nil
            and not validMultiplier(profile.damage_taken_multiplier)
        then
            return false, name
                .. ".damage_taken_multiplier must be above 0 and no greater than 10"
        end
        if profile.speed_multiplier ~= nil
            and not validSpeedMultiplier(profile.speed_multiplier)
        then
            return false, name .. ".speed_multiplier must be from 0.10 through 10.00"
        end
        if profile.overall_speed_multiplier ~= nil
            and not validSpeedMultiplier(profile.overall_speed_multiplier)
        then
            return false, name
                .. ".OVERALL_SPEED must be from 0.10 through 10.00"
        end
        if type(profile.animation_speed_multipliers) ~= "table" then
            return false, name .. ".ANIMATION_SPEED must be a table"
        end
        if type(profile.safe_speed_animations) ~= "table" then
            return false, name .. ".safe_speed_animations is not a table"
        end

        profile.name = name
        profile.model_codes = profile.model_codes or {}
        profile.fingerprints = profile.fingerprints or {}
        profile.animationSpeedMultiplierMap = {}
        for animationId, multiplier in pairs(
            profile.animation_speed_multipliers
        ) do
            if type(animationId) ~= "number"
                or animationId < 0
                or animationId > 255
                or animationId ~= math.floor(animationId)
            then
                return false, name
                    .. ".ANIMATION_SPEED contains an invalid animation ID"
            end
            if not validSpeedMultiplier(multiplier) then
                return false, name
                    .. ".ANIMATION_SPEED multiplier must be from 0.10 through 10.00"
            end
            profile.animationSpeedMultiplierMap[animationId] = multiplier
        end
        profile.safeSpeedAnimationSet = {}
        for _, animationId in ipairs(profile.safe_speed_animations) do
            if type(animationId) ~= "number"
                or animationId < 0
                or animationId > 255
                or animationId ~= math.floor(animationId)
            then
                return false, name
                    .. ".safe_speed_animations contains an invalid ID"
            end
            profile.safeSpeedAnimationSet[animationId] = true
        end

        for _, rawCode in ipairs(profile.model_codes) do
            local code = normalizeModelCode(rawCode)
            if code ~= nil then
                local existing = modelCodeProfiles[code]
                if existing ~= nil and existing ~= profile then
                    profileWarnings[#profileWarnings + 1] = string.format(
                        "duplicate model code %s belongs to both %s and %s; %s wins",
                        code,
                        existing.name,
                        name,
                        existing.name
                    )
                else
                    modelCodeProfiles[code] = profile
                end
            end
        end

        for _, fingerprint in ipairs(profile.fingerprints) do
            if type(fingerprint) == "string" and fingerprint ~= "" then
                local existing = fingerprintProfiles[fingerprint]
                if existing ~= nil and existing ~= profile then
                    profileWarnings[#profileWarnings + 1] = string.format(
                        "duplicate fingerprint %s belongs to both %s and %s; %s wins",
                        fingerprint,
                        existing.name,
                        name,
                        existing.name
                    )
                else
                    fingerprintProfiles[fingerprint] = profile
                end
            end
        end
    end

    if type(SETTINGS.FINGERPRINT_PROFILE_BINDINGS) ~= "table" then
        return false, "FINGERPRINT_PROFILE_BINDINGS is not a table"
    end
    for fingerprint, enemyName in pairs(
        SETTINGS.FINGERPRINT_PROFILE_BINDINGS
    ) do
        if type(fingerprint) ~= "string" or fingerprint == ""
            or type(enemyName) ~= "string"
        then
            return false, "fingerprint bindings must map a fingerprint string to an enemy name"
        end

        local profile = SETTINGS.ENEMIES[enemyName]
        if profile == nil then
            return false, "fingerprint binding names unknown enemy row "
                .. tostring(enemyName)
        end

        local existing = fingerprintProfiles[fingerprint]
        if existing ~= nil and existing ~= profile then
            profileWarnings[#profileWarnings + 1] = string.format(
                "explicit fingerprint binding %s overrides %s with %s",
                fingerprint,
                existing.name,
                profile.name
            )
        end
        fingerprintProfiles[fingerprint] = profile
    end

    if type(SETTINGS.TARGET_CONTEXT_PROFILE_BINDINGS) ~= "table" then
        return false, "TARGET_CONTEXT_PROFILE_BINDINGS is not a table"
    end
    local contextKeys = {}
    for index, binding in ipairs(
        SETTINGS.TARGET_CONTEXT_PROFILE_BINDINGS
    ) do
        if type(binding) ~= "table" then
            return false, "target context binding " .. tostring(index)
                .. " is not a table"
        end
        local profile = SETTINGS.ENEMIES[binding.enemy]
        if profile == nil then
            return false, "target context binding " .. tostring(index)
                .. " names unknown enemy row " .. tostring(binding.enemy)
        end
        if type(binding.world) ~= "number"
            or binding.world < 0 or binding.world > 255
            or binding.world ~= math.floor(binding.world)
        then
            return false, "target context binding " .. tostring(index)
                .. " has an invalid world byte"
        end
        if binding.room ~= nil
            and (
                type(binding.room) ~= "number"
                or binding.room < 0 or binding.room > 255
                or binding.room ~= math.floor(binding.room)
            )
        then
            return false, "target context binding " .. tostring(index)
                .. " has an invalid room byte"
        end
        if type(binding.native_max_hp) ~= "number"
            or binding.native_max_hp < 1
            or binding.native_max_hp > MAX_HP_STORAGE_VALUE
            or binding.native_max_hp ~= math.floor(binding.native_max_hp)
        then
            return false, "target context binding " .. tostring(index)
                .. " has an invalid native_max_hp"
        end
        if binding.fingerprint ~= nil
            and (
                type(binding.fingerprint) ~= "string"
                or binding.fingerprint == ""
            )
        then
            return false, "target context binding " .. tostring(index)
                .. " has an invalid fingerprint"
        end

        local contextKey = string.format(
            "%02X:%s:%u:%s",
            binding.world,
            binding.room ~= nil
                and string.format("%02X", binding.room)
                or "*",
            binding.native_max_hp,
            binding.fingerprint or "*"
        )
        local existing = contextKeys[contextKey]
        if existing ~= nil and existing ~= profile then
            return false, "target context " .. contextKey
                .. " maps to both " .. existing.name
                .. " and " .. profile.name
        end
        contextKeys[contextKey] = profile
        targetContextProfileBindings[
            #targetContextProfileBindings + 1
        ] = {
            profile = profile,
            world = binding.world,
            room = binding.room,
            nativeMaxHp = binding.native_max_hp,
            fingerprint = binding.fingerprint,
            key = contextKey,
        }
    end

    return true
end

local function profileHpMultiplier(profile)
    if profile.hp_multiplier ~= nil then
        return profile.hp_multiplier
    end
    return SETTINGS.GLOBAL.HP_MULTIPLIER
end

local function profileExactMaximum(profile)
    if profile.max_hp ~= nil then
        return profile.max_hp
    end
    if profile.hp_multiplier ~= nil then
        return nil
    end
    return SETTINGS.GLOBAL.MAX_HP
end

local function profileHpSettingSource(profile)
    local profilePrefix = profile.is_confirmed_target_fallback
        and "CONFIRMED_TARGET_FALLBACK"
        or tostring(profile.name)
    if profile.max_hp ~= nil then
        return profilePrefix .. ".max_hp"
    end
    if profile.hp_multiplier ~= nil then
        return profilePrefix .. ".hp_multiplier"
    end
    if SETTINGS.GLOBAL.MAX_HP ~= nil then
        return "GLOBAL.MAX_HP"
    end
    return "GLOBAL.HP_MULTIPLIER"
end

local function profileDamageTakenMultiplier(profile)
    if profile.damage_taken_multiplier ~= nil then
        return profile.damage_taken_multiplier
    end
    return SETTINGS.GLOBAL.DAMAGE_TAKEN_MULTIPLIER
end

local function publishedDamageTakenMultiplier(encodedStatPage)
    for slot = 0, HOOK_TARGET_SLOT_COUNT - 1 do
        local slotAddress = HOOK_TARGET_TABLE_RVA
            + slot * HOOK_TARGET_SLOT_SIZE
        local publishedId = safeReadInt(slotAddress, false)
        if publishedId == encodedStatPage then
            return safeReadFloat(slotAddress + 4, false), slot
        end
    end
    return safeReadFloat(HOOK_DEFAULT_TAKEN_RVA, false), -1
end

local function profileSpeedMultiplier(profile, animation)
    if profile.animationSpeedMultiplierMap ~= nil
        and profile.animationSpeedMultiplierMap[animation] ~= nil
    then
        return profile.animationSpeedMultiplierMap[animation], "animation"
    end
    if profile.overall_speed_multiplier ~= nil then
        return profile.overall_speed_multiplier, "overall"
    end
    return nil, "native"
end

-- =========================================================================
-- MODEL IDENTIFICATION
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
    local textureInfoSize = safeReadInt(
        mobj + MOBJ_TEXTURE_INFO_SIZE_OFFSET,
        true
    )
    local textureDataSize = safeReadInt(
        mobj + MOBJ_TEXTURE_DATA_SIZE_OFFSET,
        true
    )
    local modelSize = safeReadInt(mobj + MOBJ_MODEL_SIZE_OFFSET, true)
    local modelEncoded = safeReadInt(
        mobj + MOBJ_MODEL_POINTER_OFFSET,
        true
    )

    if dataSize == nil or textureInfoSize == nil
        or textureDataSize == nil or modelSize == nil
        or dataSize < 0x100 or dataSize > 0x2000000
    then
        return nil
    end

    local model = resolveCompressedPointer(modelEncoded)
    if not plausibleRuntimeAddress(model) then
        return nil
    end

    local jointCount = safeReadInt(
        model + MODEL_JOINT_COUNT_OFFSET,
        true
    )
    local meshCount = safeReadInt(
        model + MODEL_MESH_COUNT_OFFSET,
        true
    )
    if jointCount == nil or meshCount == nil
        or jointCount < 1 or jointCount > 4096
        or meshCount < 1 or meshCount > 1024
    then
        return nil
    end

    local fingerprint = string.format(
        "%08X:%08X:%08X:%08X:%04X:%04X",
        dataSize,
        textureInfoSize,
        textureDataSize,
        modelSize,
        jointCount,
        meshCount
    )

    return {
        mobj = mobj,
        model = model,
        dataSize = dataSize,
        jointCount = jointCount,
        meshCount = meshCount,
        fingerprint = fingerprint,
        pointerSource = pointerSource or "unknown",
    }
end

local function readMobjIdentity(object)
    -- Sora uses the verified direct path at +0x154. Try it first because it is
    -- cheap and several enemy actor classes may share the same layout.
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

    -- Enemy wrappers do not consistently keep MOBJ at +0x154. Probe direct
    -- references embedded in the first 0x400 bytes of the live actor.
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

    -- Some combat actors point to a small owner/wrapper that then points to
    -- the MOBJ. Limit this second hop so identification remains bounded.
    local outerCount = math.min(#references, MAX_MODEL_REFERENCE_PROBES)
    for index = 1, outerCount do
        local reference = references[index]
        local wrapperBytes = safeReadArray(reference.address, 0x200, true)
        if wrapperBytes ~= nil then
            for offset = 0, #wrapperBytes - 4, 4 do
                local value32 = bytesU32(wrapperBytes, offset + 1)
                if value32 >= 0x80000000 then
                    local identity = readMobjIdentityAt(
                        resolveCompressedPointer(value32),
                        string.format(
                            "%s->+0x%03X(compressed)",
                            reference.source,
                            offset
                        )
                    )
                    if identity ~= nil then
                        return identity
                    end
                end

                if offset % 8 == 0
                    and offset <= #wrapperBytes - 8
                then
                    local identity = readMobjIdentityAt(
                        bytesU64(wrapperBytes, offset + 1),
                        string.format(
                            "%s->+0x%03X(direct64)",
                            reference.source,
                            offset
                        )
                    )
                    if identity ~= nil then
                        return identity
                    end
                end
            end
        end
    end

    return nil
end

local function appendUniqueReference(list, seen, address)
    if not plausibleRuntimeAddress(address) then
        return
    end
    local key = addressKey(address)
    if seen[key] then
        return
    end
    seen[key] = true
    list[#list + 1] = address
end

local function findModelCode(object, mobjIdentity)
    local objectBytes = safeReadArray(object, 0x400, true)
    local directCode = extractModelCode(objectBytes)
    if directCode ~= nil then
        return directCode
    end

    if mobjIdentity ~= nil then
        local mobjBytes = safeReadArray(mobjIdentity.mobj, 0x100, true)
        directCode = extractModelCode(mobjBytes)
        if directCode ~= nil then
            return directCode
        end

        local beforeMobj = safeReadArray(
            mobjIdentity.mobj - 0x100,
            0x200,
            true
        )
        directCode = extractModelCode(beforeMobj)
        if directCode ~= nil then
            return directCode
        end
    end

    if objectBytes == nil then
        return nil
    end

    local references = {}
    local seenReferences = {}
    for offset = 0, #objectBytes - 4, 4 do
        local value32 = bytesU32(objectBytes, offset + 1)
        if value32 >= 0x80000000 then
            appendUniqueReference(
                references,
                seenReferences,
                resolveCompressedPointer(value32)
            )
        end

        if offset % 8 == 0 and offset <= #objectBytes - 8 then
            appendUniqueReference(
                references,
                seenReferences,
                bytesU64(objectBytes, offset + 1)
            )
        end

        if #references >= MAX_MODEL_REFERENCE_PROBES then
            break
        end
    end

    local probes = math.min(#references, MAX_MODEL_REFERENCE_PROBES)
    for index = 1, probes do
        local bytes = safeReadArray(references[index], 0xA0, true)
        local code = extractModelCode(bytes)
        if code ~= nil then
            return code
        end
    end

    return nil
end

local function identifyContextProfile(nativeMaxHp, fingerprint)
    local worldId = safeReadByte(WORLD_ADDRESS)
    local roomId = safeReadByte(ROOM_ADDRESS)
    if worldId == nil or roomId == nil or nativeMaxHp == nil then
        return nil, worldId, roomId, nil
    end

    for _, binding in ipairs(targetContextProfileBindings) do
        if binding.world == worldId
            and (binding.room == nil or binding.room == roomId)
            and binding.nativeMaxHp == nativeMaxHp
            and (
                binding.fingerprint == nil
                or binding.fingerprint == fingerprint
            )
        then
            return binding.profile, worldId, roomId, binding.key
        end
    end
    return nil, worldId, roomId, nil
end

local function identifyProfile(object, nativeMaxHp)
    local mobjIdentity = readMobjIdentity(object)
    local modelCode = findModelCode(object, mobjIdentity)
    local profile = nil
    local matchSource = nil
    local fingerprint = mobjIdentity ~= nil
        and mobjIdentity.fingerprint
        or nil

    if modelCode ~= nil then
        profile = modelCodeProfiles[normalizeModelCode(modelCode)]
        if profile ~= nil then
            matchSource = "model_code:" .. tostring(modelCode)
        end
    end

    if profile == nil and mobjIdentity ~= nil then
        profile = fingerprintProfiles[mobjIdentity.fingerprint]
        if profile ~= nil then
            matchSource = "fingerprint:" .. mobjIdentity.fingerprint
        end
    end
    local contextProfile, worldId, roomId, contextKey =
        identifyContextProfile(nativeMaxHp, fingerprint)
    if profile == nil and contextProfile ~= nil then
        profile = contextProfile
        matchSource = "target_context:" .. contextKey
    end

    return profile, modelCode, mobjIdentity, matchSource, worldId, roomId
end

-- =========================================================================
-- ENTITY READING AND HEALTH WRITES
-- =========================================================================

local function readEntity(address)
    if not plausibleRuntimeAddress(address) or address == currentSora then
        return nil
    end

    local encodedStatPage = safeReadInt(
        address + ENTITY_STAT_PAGE_OFFSET,
        true
    )
    if encodedStatPage == nil or encodedStatPage == 0 then
        return nil
    end

    local statPage = resolveCompressedPointer(encodedStatPage)
    if not plausibleRuntimeAddress(statPage) then
        return nil
    end

    local hp = safeReadInt(statPage + STAT_CURRENT_HP_OFFSET, true)
    local maxHp = safeReadInt(statPage + STAT_MAX_HP_OFFSET, true)
    if hp == nil or maxHp == nil
        or maxHp == 0 or maxHp > MAX_HP_STORAGE_VALUE
        or hp == 0 or hp > maxHp
    then
        return nil
    end

    return {
        object = address,
        statPage = statPage,
        encodedStatPage = encodedStatPage,
        hp = hp,
        maxHp = maxHp,
    }
end


local function sharedTargetKey(object, statPage)
    return addressKey(object) .. ":" .. addressKey(statPage)
end

local function matchNonEnemyExclusion(entity)
    local key = sharedTargetKey(entity.object, entity.statPage)
    local remembered = SHARED._excludedTargets[key]
    if remembered ~= nil then
        return remembered, key
    end

    local identity = readMobjIdentity(entity.object)
    if identity == nil or identity.fingerprint == nil then
        return nil, key
    end
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    for _, exclusion in ipairs(SETTINGS.NON_ENEMY_EXCLUSIONS or {}) do
        local hpMatches = false
        for _, value in ipairs(exclusion.max_hp_values or {}) do
            if value == entity.maxHp then
                hpMatches = true
                break
            end
        end
        if hpMatches
            and world == exclusion.world
            and (exclusion.room == nil or room == exclusion.room)
            and identity.fingerprint == exclusion.fingerprint
        then
            SHARED._excludedTargets[key] = exclusion.label
            return exclusion.label, key
        end
    end
    return nil, key
end

local function rounded(value)
    return math.floor(value + 0.5)
end

local function desiredMaximumHp(profile, originalMaxHp)
    local exactMaximum = profileExactMaximum(profile)
    if exactMaximum ~= nil then
        return math.max(
            1,
            math.min(MAX_HP_STORAGE_VALUE, rounded(exactMaximum))
        )
    end
    return math.max(
        1,
        math.min(
            MAX_HP_STORAGE_VALUE,
            rounded(originalMaxHp * profileHpMultiplier(profile))
        )
    )
end

local function candidateHealthIdentity(candidate)
    if candidate.mobjIdentity ~= nil
        and candidate.mobjIdentity.fingerprint ~= nil
    then
        return "fingerprint:" .. candidate.mobjIdentity.fingerprint
    end
    if candidate.profile ~= nil
        and not candidate.profile.is_confirmed_target_fallback
    then
        return "profile:" .. tostring(candidate.profile.name)
    end
    return nil
end

local function resolveHealthBaseline(candidate, currentMaxHp)
    local key = addressKey(candidate.statPage)
    local baseline = healthBaselines[key]
    local identity = candidateHealthIdentity(candidate)

    if baseline ~= nil
        and baseline.sourceMaxHp ~= nil
        and baseline.sourceMaxHp > 0
        and baseline.appliedMaxHp ~= nil
        and currentMaxHp == baseline.appliedMaxHp
    then
        local wrapperChanged = baseline.object ~= candidate.object
        local identityChanged = baseline.identity ~= nil
            and identity ~= nil
            and baseline.identity ~= identity
        local restored =
            candidate.sourceMaxHp ~= baseline.sourceMaxHp
            or candidate.appliedMaxHp ~= baseline.appliedMaxHp
            or wrapperChanged
        baseline.object = candidate.object
        baseline.identity = identity or baseline.identity
        candidate.sourceMaxHp = baseline.sourceMaxHp
        candidate.appliedMaxHp = baseline.appliedMaxHp
        candidate.wrapperRebound = wrapperChanged
        candidate.identityRebound = identityChanged
        return baseline, restored
    end

    -- A wrapper or MOBJ fingerprint can change while the same stat page still
    -- contains the maximum this script applied. Those changes are deliberately
    -- ignored above. Only a genuinely different maximum (or a new page) is
    -- accepted as a fresh native baseline.
    baseline = {
        object = candidate.object,
        sourceMaxHp = currentMaxHp,
        appliedMaxHp = nil,
        identity = identity,
        restoreLogged = false,
    }
    healthBaselines[key] = baseline
    candidate.sourceMaxHp = currentMaxHp
    candidate.appliedMaxHp = nil
    candidate.wrapperRebound = false
    candidate.identityRebound = false
    return baseline, false
end

local function applyHealth(candidate, currentHp, currentMaxHp)
    local profile = candidate.profile
    if profile == nil or profile.enabled == false then
        return true
    end

    local baseline, restored = resolveHealthBaseline(
        candidate,
        currentMaxHp
    )
    local originalMaxHp = baseline.sourceMaxHp
    local desiredMaxHp = desiredMaximumHp(profile, originalMaxHp)
    if desiredMaxHp == currentMaxHp then
        candidate.sourceMaxHp = originalMaxHp
        candidate.appliedMaxHp = currentMaxHp
        baseline.appliedMaxHp = currentMaxHp
        if restored and not baseline.restoreLogged then
            baseline.restoreLogged = true
            record(string.format(
                "HP BASELINE RESTORED tick=%d enemy=%s "
                    .. "base_max=%u applied_max=%u wrapper_rebound=%s "
                    .. "identity_rebound=%s setting_source=%s",
                tick,
                profile.name,
                originalMaxHp,
                currentMaxHp,
                tostring(candidate.wrapperRebound == true),
                tostring(candidate.identityRebound == true),
                profileHpSettingSource(profile)
            ), true)
        end
        return true
    end

    local desiredCurrentHp
    if SETTINGS.GLOBAL.PRESERVE_CURRENT_HP_RATIO then
        desiredCurrentHp = rounded(
            (currentHp / currentMaxHp) * desiredMaxHp
        )
    else
        desiredCurrentHp = desiredMaxHp
    end
    desiredCurrentHp = math.max(1, math.min(desiredMaxHp, desiredCurrentHp))

    local ok
    local reason
    if desiredMaxHp < currentHp then
        ok, reason = safeWriteInt(
            candidate.statPage + STAT_CURRENT_HP_OFFSET,
            desiredCurrentHp,
            true
        )
        if ok then
            ok, reason = safeWriteInt(
                candidate.statPage + STAT_MAX_HP_OFFSET,
                desiredMaxHp,
                true
            )
        end
    else
        ok, reason = safeWriteInt(
            candidate.statPage + STAT_MAX_HP_OFFSET,
            desiredMaxHp,
            true
        )
        if ok then
            ok, reason = safeWriteInt(
                candidate.statPage + STAT_CURRENT_HP_OFFSET,
                desiredCurrentHp,
                true
            )
        end
    end

    if not ok then
        record(string.format(
            "HP WRITE FAILED tick=%d enemy=%s object=%s stat_page=%s reason=%s",
            tick,
            profile.name,
            pointerText(candidate.object),
            pointerText(candidate.statPage),
            tostring(reason)
        ), true)
        return false
    end

    candidate.hp = desiredCurrentHp
    candidate.maxHp = desiredMaxHp
    candidate.sourceMaxHp = originalMaxHp
    candidate.appliedMaxHp = desiredMaxHp
    baseline.appliedMaxHp = desiredMaxHp

    record(string.format(
        "HP APPLIED tick=%d enemy=%s HP=%u/%u -> %u/%u "
            .. "base_max=%u hp_multiplier=%.3f exact_max=%s "
            .. "setting_source=%s",
        tick,
        profile.name,
        currentHp,
        currentMaxHp,
        desiredCurrentHp,
        desiredMaxHp,
        originalMaxHp,
        profileHpMultiplier(profile),
        tostring(profileExactMaximum(profile)),
        profileHpSettingSource(profile)
    ), true)
    saveReport()
    return true
end

local function registerCandidate(address, source, isConfirmedTarget)
    local entity = readEntity(address)
    if entity == nil then
        return false
    end

    local exclusionLabel, exclusionKey = matchNonEnemyExclusion(entity)
    if exclusionLabel ~= nil then
        if not SHARED._excludedStatsLogged[exclusionKey] then
            SHARED._excludedStatsLogged[exclusionKey] = true
            record(string.format(
                "NON-ENEMY TARGET BLOCKED tick=%d label=%s " ..
                    "source=%s object=%s stat_page=%s HP=%u/%u",
                tick,
                exclusionLabel,
                source or "unknown",
                pointerText(entity.object),
                pointerText(entity.statPage),
                entity.hp,
                entity.maxHp
            ), true)
        end
        return false
    end

    local key = addressKey(entity.statPage)
    local existing = candidates[key]
    if existing ~= nil then
        local wrapperChanged = existing.object ~= entity.object
        if wrapperChanged then
            existing.speedWriteDisabled = false
            existing.speedActiveKey = nil
            existing.movementWriteDisabled = false
            existing.movementActiveKey = nil
            existing.movementLastObject = nil
            existing.movementLastX = nil
            existing.movementLastZ = nil
            existing.movementWarpLogged = nil
        end
        if wrapperChanged
            or (
                isConfirmedTarget
                and (
                    existing.profile == nil
                    or existing.isConfirmedTargetFallback
                )
            )
        then
            local reboundProfile, reboundCode, reboundIdentity,
                reboundMatchSource, reboundWorld, reboundRoom =
                identifyProfile(entity.object, entity.maxHp)
            existing.modelCode = reboundCode or existing.modelCode
            existing.mobjIdentity = reboundIdentity or existing.mobjIdentity
            existing.profileMatchSource =
                reboundMatchSource or existing.profileMatchSource
            existing.worldId = reboundWorld or existing.worldId
            existing.roomId = reboundRoom or existing.roomId
            if reboundProfile ~= nil then
                local previousName = existing.profile ~= nil
                    and existing.profile.name
                    or "none"
                existing.profile = reboundProfile
                existing.isConfirmedTargetFallback = false
                if previousName ~= reboundProfile.name then
                    record(string.format(
                        "PROFILE BOUND tick=%d "
                            .. "fingerprint=%s enemy=%s previous=%s "
                            .. "world=%s room=%s native_max=%u "
                            .. "match_source=%s stat_page=%s",
                        tick,
                        reboundIdentity ~= nil
                            and reboundIdentity.fingerprint
                            or "none",
                        reboundProfile.name,
                        previousName,
                        tostring(existing.worldId),
                        tostring(existing.roomId),
                        entity.maxHp,
                        reboundMatchSource or "unknown",
                        pointerText(existing.statPage)
                    ), true)
                end
            end
        end
        existing.object = entity.object
        existing.encodedStatPage = entity.encodedStatPage
        if isConfirmedTarget then
            existing.confirmedCombatTarget = true
            existing.source = source or existing.source
        end
        if existing.source == nil then
            existing.source = source
        end
        if isConfirmedTarget
            and SETTINGS.ENABLE_CONFIRMED_TARGET_FALLBACK
            and existing.profile == nil
        then
            existing.profile = CONFIRMED_TARGET_FALLBACK_PROFILE
            existing.isConfirmedTargetFallback = true
            existing.source = source or existing.source
            local fallbackKey = addressKey(existing.statPage)
            if not identifiedLogged["fallback:" .. fallbackKey] then
                identifiedLogged["fallback:" .. fallbackKey] = true
                record(string.format(
                    "COMBAT TARGET CONFIRMED tick=%d model=%s fingerprint=%s "
                        .. "world=%s room=%s mobj_source=%s "
                        .. "object=%s stat_page=%s "
                        .. "encoded=0x%08X HP=%u/%u source=%s",
                    tick,
                    existing.modelCode or "none",
                    existing.mobjIdentity ~= nil
                        and existing.mobjIdentity.fingerprint
                        or "none",
                    tostring(existing.worldId),
                    tostring(existing.roomId),
                    existing.mobjIdentity ~= nil
                        and existing.mobjIdentity.pointerSource
                        or "none",
                    pointerText(existing.object),
                    pointerText(existing.statPage),
                    existing.encodedStatPage,
                    entity.hp,
                    entity.maxHp,
                    existing.source or "unknown"
                ), true)
            end
        end
        if isConfirmedTarget
            and existing.profile ~= nil
            and existing.profile.enabled ~= false
        then
            if not existing.isConfirmedTargetFallback then
                local confirmedKey = "confirmed:" .. addressKey(existing.statPage)
                if not identifiedLogged[confirmedKey] then
                    identifiedLogged[confirmedKey] = true
                    record(string.format(
                        "COMBAT TARGET CONFIRMED tick=%d enemy=%s "
                            .. "world=%s room=%s match_source=%s "
                            .. "object=%s stat_page=%s encoded=0x%08X "
                            .. "HP=%u/%u source=%s",
                        tick,
                        existing.profile.name,
                        tostring(existing.worldId),
                        tostring(existing.roomId),
                        existing.profileMatchSource or "unknown",
                        pointerText(existing.object),
                        pointerText(existing.statPage),
                        existing.encodedStatPage,
                        entity.hp,
                        entity.maxHp,
                        existing.source or "unknown"
                    ), true)
                end
            end
            applyHealth(existing, entity.hp, entity.maxHp)
        end
        return true
    end

    if candidateCount >= MAX_ENTITY_CANDIDATES then
        return false
    end

    local profile, modelCode, mobjIdentity, profileMatchSource,
        worldId, roomId = identifyProfile(entity.object, entity.maxHp)
    local usingFallback = false
    if profile == nil
        and isConfirmedTarget
        and SETTINGS.ENABLE_CONFIRMED_TARGET_FALLBACK
    then
        profile = CONFIRMED_TARGET_FALLBACK_PROFILE
        usingFallback = true
    end

    entity.source = source or "unknown"
    entity.profile = profile
    entity.modelCode = modelCode
    entity.mobjIdentity = mobjIdentity
    entity.profileMatchSource = profileMatchSource
    entity.worldId = worldId
    entity.roomId = roomId
    entity.isConfirmedTargetFallback = usingFallback
    entity.confirmedCombatTarget = isConfirmedTarget == true
    entity.sourceMaxHp = entity.maxHp
    entity.appliedMaxHp = nil
    entity.speedWriteDisabled = false
    entity.speedActiveKey = nil
    entity.movementWriteDisabled = false
    entity.movementActiveKey = nil
    entity.movementLastObject = nil
    entity.movementLastX = nil
    entity.movementLastZ = nil
    entity.movementWarpLogged = nil

    candidates[key] = entity
    candidateOrder[#candidateOrder + 1] = key
    candidateCount = candidateCount + 1

    local fingerprint = mobjIdentity ~= nil
        and mobjIdentity.fingerprint
        or "none"
    local codeText = modelCode or "none"

    if profile ~= nil and not usingFallback then
        local identifiedKey = profile.name .. ":" .. codeText .. ":" .. fingerprint
        if not identifiedLogged[identifiedKey] then
            identifiedLogged[identifiedKey] = true
            record(string.format(
                "IDENTIFIED tick=%d enemy=%s model=%s fingerprint=%s "
                    .. "world=%s room=%s native_max=%u match_source=%s "
                    .. "mobj_source=%s object=%s stat_page=%s "
                    .. "encoded=0x%08X HP=%u/%u",
                tick,
                profile.name,
                codeText,
                fingerprint,
                tostring(worldId),
                tostring(roomId),
                entity.maxHp,
                profileMatchSource or "unknown",
                mobjIdentity ~= nil
                    and mobjIdentity.pointerSource
                    or "none",
                pointerText(entity.object),
                pointerText(entity.statPage),
                entity.encodedStatPage,
                entity.hp,
                entity.maxHp
            ), SETTINGS.LOG_IDENTIFIED_ENEMIES)
        end

        if entity.confirmedCombatTarget
            and profile.enabled ~= false
        then
            applyHealth(entity, entity.hp, entity.maxHp)
        end
    elseif usingFallback then
        local fallbackKey = addressKey(entity.statPage)
        if not identifiedLogged["fallback:" .. fallbackKey] then
            identifiedLogged["fallback:" .. fallbackKey] = true
            record(string.format(
                "COMBAT TARGET CONFIRMED tick=%d model=%s fingerprint=%s "
                    .. "world=%s room=%s mobj_source=%s "
                    .. "object=%s stat_page=%s "
                    .. "encoded=0x%08X HP=%u/%u source=%s",
                tick,
                codeText,
                fingerprint,
                tostring(worldId),
                tostring(roomId),
                mobjIdentity ~= nil
                    and mobjIdentity.pointerSource
                    or "none",
                pointerText(entity.object),
                pointerText(entity.statPage),
                entity.encodedStatPage,
                entity.hp,
                entity.maxHp,
                entity.source
            ), true)
        end
        applyHealth(entity, entity.hp, entity.maxHp)
    else
        local unresolvedKey = codeText .. ":" .. fingerprint
        if not unresolvedLogged[unresolvedKey] then
            unresolvedLogged[unresolvedKey] = true
            record(string.format(
                "UNRESOLVED tick=%d model=%s fingerprint=%s "
                    .. "world=%s room=%s object=%s stat_page=%s "
                    .. "encoded=0x%08X HP=%u/%u source=%s",
                tick,
                codeText,
                fingerprint,
                tostring(worldId),
                tostring(roomId),
                pointerText(entity.object),
                pointerText(entity.statPage),
                entity.encodedStatPage,
                entity.hp,
                entity.maxHp,
                entity.source
            ), SETTINGS.LOG_UNRESOLVED_MODELS)
        end
    end

    return true
end

local function refreshCandidates()
    for _, key in ipairs(candidateOrder) do
        local candidate = candidates[key]
        if candidate ~= nil then
            local hp = safeReadInt(
                candidate.statPage + STAT_CURRENT_HP_OFFSET,
                true
            )
            local maxHp = safeReadInt(
                candidate.statPage + STAT_MAX_HP_OFFSET,
                true
            )

            if hp ~= nil and maxHp ~= nil
                and maxHp > 0 and maxHp <= MAX_HP_STORAGE_VALUE
                and hp <= maxHp
            then
                candidate.hp = hp
                candidate.maxHp = maxHp

                if candidate.profile ~= nil
                    and candidate.confirmedCombatTarget
                    and candidate.profile.enabled ~= false
                    and hp > 0
                    and (
                        candidate.appliedMaxHp == nil
                        or maxHp ~= candidate.appliedMaxHp
                    )
                then
                    applyHealth(candidate, hp, maxHp)
                end
            end
        end
    end
end

local function candidateObjectStillMatches(candidate)
    if candidate == nil
        or not plausibleRuntimeAddress(candidate.object)
        or candidate.object == currentSora
    then
        return false
    end

    local encodedStatPage = safeReadInt(
        candidate.object + ENTITY_STAT_PAGE_OFFSET,
        true
    )
    if encodedStatPage == nil or encodedStatPage == 0 then
        return false
    end
    return resolveCompressedPointer(encodedStatPage) == candidate.statPage
end

local function observeAndApplySafeAnimationSpeed(candidate)
    if candidate == nil
        or candidate.profile == nil
        or not candidate.confirmedCombatTarget
        or candidate.profile.enabled == false
        or candidate.hp == nil
        or candidate.hp == 0
        or not candidateObjectStillMatches(candidate)
    then
        return
    end

    local action = safeReadInt(
        candidate.object + ENTITY_ACTION_ID_OFFSET,
        true
    )
    local animation = safeReadByte(
        candidate.object + ENTITY_CURRENT_ANIMATION_OFFSET,
        true
    )
    local slotValue = safeReadInt(
        candidate.object + ENTITY_RESOLVED_MOTION_INDEX_OFFSET,
        true
    )
    if action == nil or animation == nil or slotValue == nil then
        return
    end
    local slot = slotValue % 0x10000

    local profile = candidate.profile
    local namedProfile = not candidate.isConfirmedTargetFallback
        and not profile.is_confirmed_target_fallback
    local fallbackProfileAllowed = not namedProfile
        and profile.is_confirmed_target_fallback == true
        and SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .ALLOW_CONFIRMED_TARGET_FALLBACK == true
    local speedProfileEligible = namedProfile or fallbackProfileAllowed
    local multiplier, speedMode =
        profileSpeedMultiplier(profile, animation)
    local allowed = speedProfileEligible and multiplier ~= nil
    local fingerprint = candidate.mobjIdentity ~= nil
        and candidate.mobjIdentity.fingerprint
        or "none"

    if SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.LOG_OBSERVED_ANIMATIONS then
        local observedKey = table.concat({
            profile.name or "none",
            fingerprint,
            string.format("%02X", animation),
            string.format("%08X", action),
            string.format("%04X", slot),
        }, ":")
        if not motionObservedLogged[observedKey] then
            motionObservedLogged[observedKey] = true
            record(string.format(
                "ENEMY MOTION OBSERVED tick=%d enemy=%s named=%s "
                    .. "fingerprint=%s action=0x%X animation=0x%02X "
                    .. "slot=0x%04X speed_profile_eligible=%s "
                    .. "speed_configured=%s speed_mode=%s",
                tick,
                profile.name,
                tostring(namedProfile),
                fingerprint,
                action,
                animation,
                slot,
                tostring(speedProfileEligible),
                tostring(allowed),
                speedMode
            ), false)
        end
    end

    if not SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.ENABLE
        or not allowed
        or candidate.speedWriteDisabled
    then
        return
    end

    if math.abs(multiplier - 1.0) <= 0.0001 then
        return
    end

    local animationTimeAddress =
        candidate.object + ENTITY_ANIMATION_TIME_OFFSET
    local animationTime = safeReadFloat(animationTimeAddress, true)
    if animationTime == nil
        or animationTime ~= animationTime
        or animationTime < 0.0
        or animationTime > 1000000.0
    then
        return
    end

    local adjustedTime = animationTime + multiplier - 1.0
    if adjustedTime < 0.0 then
        adjustedTime = 0.0
    end

    local written, reason = safeWriteFloat(
        animationTimeAddress,
        adjustedTime,
        true
    )
    if not written then
        candidate.speedWriteDisabled = true
        record(string.format(
            "SAFE SPEED DISABLED tick=%d enemy=%s animation=0x%02X "
                .. "object=%s reason=%s",
            tick,
            profile.name,
            animation,
            pointerText(candidate.object),
            tostring(reason)
        ), true)
        return
    end

    local activeKey = string.format(
        "%s:%02X:%.3f:%s",
        profile.name,
        animation,
        multiplier,
        speedMode
    )
    if candidate.speedActiveKey ~= activeKey then
        candidate.speedActiveKey = activeKey
        record(string.format(
            "SAFE SPEED ACTIVE tick=%d enemy=%s animation=0x%02X "
                .. "slot=0x%04X multiplier=%.3f mode=%s",
            tick,
            profile.name,
            animation,
            slot,
            multiplier,
            speedMode
        ), true)
    end
end

function SETTINGS._validMovementCoordinate(value)
    return type(value) == "number"
        and value == value
        and math.abs(value) <= 10000000.0
end

function SETTINGS._resetMovementBaseline(candidate, x, z)
    candidate.movementLastObject = candidate.object
    candidate.movementLastX = x
    candidate.movementLastZ = z
    candidate.movementActiveKey = nil
end

function SETTINGS._applySafeMovementSpeed(candidate)
    if candidate == nil
        or candidate.profile == nil
        or not candidate.confirmedCombatTarget
        or candidate.profile.enabled == false
        or candidate.hp == nil
        or candidate.hp == 0
        or not candidateObjectStillMatches(candidate)
        or SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.ENABLE ~= true
        or SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .SCALE_WORLD_MOVEMENT ~= true
    then
        return
    end

    local animation = safeReadByte(
        candidate.object + ENTITY_CURRENT_ANIMATION_OFFSET,
        true
    )
    if animation == nil then
        return
    end

    local transforms = {}
    for _, offset in ipairs(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.POSITION_VECTOR_OFFSETS
    ) do
        local x = safeReadFloat(candidate.object + offset, true)
        local z = safeReadFloat(candidate.object + offset + 8, true)
        if not SETTINGS._validMovementCoordinate(x)
            or not SETTINGS._validMovementCoordinate(z)
        then
            SETTINGS._resetMovementBaseline(candidate, nil, nil)
            return
        end
        transforms[#transforms + 1] = {
            offset = offset,
            x = x,
            z = z,
        }
    end

    local primary = transforms[1]
    if primary == nil then
        return
    end
    if candidate.movementLastObject ~= candidate.object
        or candidate.movementLastX == nil
        or candidate.movementLastZ == nil
    then
        SETTINGS._resetMovementBaseline(
            candidate,
            primary.x,
            primary.z
        )
        return
    end

    local deltaX = primary.x - candidate.movementLastX
    local deltaZ = primary.z - candidate.movementLastZ
    candidate.movementLastObject = candidate.object
    candidate.movementLastX = primary.x
    candidate.movementLastZ = primary.z

    local profile = candidate.profile
    local namedProfile = not candidate.isConfirmedTargetFallback
        and not profile.is_confirmed_target_fallback
    local fallbackProfileAllowed = not namedProfile
        and profile.is_confirmed_target_fallback == true
        and SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .ALLOW_CONFIRMED_TARGET_FALLBACK == true
    local multiplier, speedMode =
        profileSpeedMultiplier(profile, animation)
    if not (namedProfile or fallbackProfileAllowed)
        or multiplier == nil
        or math.abs(multiplier - 1.0) <= 0.0001
    then
        candidate.movementActiveKey = nil
        return
    end
    if candidate.movementWriteDisabled then
        return
    end

    local maxDelta = SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
        .MAX_HORIZONTAL_DELTA_PER_TICK
    local distanceSquared = deltaX * deltaX + deltaZ * deltaZ
    if distanceSquared > maxDelta * maxDelta then
        if not candidate.movementWarpLogged then
            candidate.movementWarpLogged = true
            record(string.format(
                "SAFE MOVEMENT WARP REJECTED tick=%d enemy=%s "
                    .. "animation=0x%02X delta_x=%.3f delta_z=%.3f "
                    .. "limit=%.3f",
                tick,
                profile.name,
                animation,
                deltaX,
                deltaZ,
                maxDelta
            ), true)
        end
        return
    end

    local extraX = deltaX * (multiplier - 1.0)
    local extraZ = deltaZ * (multiplier - 1.0)
    if math.abs(extraX) <= 0.000001
        and math.abs(extraZ) <= 0.000001
    then
        return
    end

    for _, transform in ipairs(transforms) do
        local xWritten, xReason = safeWriteFloat(
            candidate.object + transform.offset,
            transform.x + extraX,
            true
        )
        local zWritten = false
        local zReason = "X write failed"
        if xWritten then
            zWritten, zReason = safeWriteFloat(
                candidate.object + transform.offset + 8,
                transform.z + extraZ,
                true
            )
        end
        if not xWritten or not zWritten then
            candidate.movementWriteDisabled = true
            record(string.format(
                "SAFE MOVEMENT DISABLED tick=%d enemy=%s "
                    .. "animation=0x%02X object=%s offset=0x%X "
                    .. "reason=%s",
                tick,
                profile.name,
                animation,
                pointerText(candidate.object),
                transform.offset,
                tostring(xWritten and zReason or xReason)
            ), true)
            return
        end
    end

    candidate.movementLastX = primary.x + extraX
    candidate.movementLastZ = primary.z + extraZ
    local activeKey = string.format(
        "%s:%02X:%.3f:%s",
        profile.name,
        animation,
        multiplier,
        speedMode
    )
    if candidate.movementActiveKey ~= activeKey then
        candidate.movementActiveKey = activeKey
        record(string.format(
            "SAFE MOVEMENT ACTIVE tick=%d enemy=%s "
                .. "animation=0x%02X multiplier=%.3f mode=%s "
                .. "delta_x=%.3f delta_z=%.3f "
                .. "scaled_delta_x=%.3f scaled_delta_z=%.3f",
            tick,
            profile.name,
            animation,
            multiplier,
            speedMode,
            deltaX,
            deltaZ,
            deltaX + extraX,
            deltaZ + extraZ
        ), true)
    end
end

local function updateSafeAnimationSpeeds()
    for _, key in ipairs(candidateOrder) do
        local candidate = candidates[key]
        observeAndApplySafeAnimationSpeed(candidate)
        SETTINGS._applySafeMovementSpeed(candidate)
    end
end

local function addLockOnTarget(targets, seen, address, source)
    if not plausibleRuntimeAddress(address)
        or address == currentSora
        or readEntity(address) == nil
    then
        return
    end

    local key = addressKey(address)
    if seen[key] then
        return
    end
    seen[key] = true
    targets[#targets + 1] = {
        address = address,
        source = source,
    }
end

local function collectLiveLockOnTargets()
    local targets = {}
    local seen = {}

    -- Previously validated narrow lock-on global. Probe both representations
    -- because Steam rooms can publish either a direct or compressed pointer.
    addLockOnTarget(
        targets,
        seen,
        safeReadLong(LOCK_ON_TARGET_POINTER),
        "module+0x25387F0(direct64)"
    )
    local globalEncoded = safeReadInt(LOCK_ON_TARGET_POINTER)
    if globalEncoded ~= nil and globalEncoded ~= 0 then
        addLockOnTarget(
            targets,
            seen,
            resolveCompressedPointer(globalEncoded),
            "module+0x25387F0(compressed32)"
        )
    end

    -- Sora+0x74 is also processed independently before damage so stats can
    -- activate pre-hit. It remains here to corroborate native damage events.
    if currentSora ~= 0 then
        local soraEncoded = safeReadInt(
            currentSora + SORA_LOCK_ON_TARGET_OFFSET,
            true
        )
        if soraEncoded ~= nil and soraEncoded ~= 0 then
            addLockOnTarget(
                targets,
                seen,
                resolveCompressedPointer(soraEncoded),
                "Sora+0x74(compressed)"
            )
        end
    end

    return targets
end

local function processPreHitLiveTarget()
    if currentSora == 0 then
        lastPreHitTarget = 0
        return
    end

    -- Runtime report v2.0 proved this exact route reached the real enemy at
    -- 75/75 HP before the first native damage event. Do not broaden this to
    -- graph references or the disproven owner+0x2EC route.
    local encodedTarget = safeReadInt(
        currentSora + SORA_LOCK_ON_TARGET_OFFSET,
        true
    )
    if encodedTarget == nil or encodedTarget == 0 then
        lastPreHitTarget = 0
        return
    end

    local target = resolveCompressedPointer(encodedTarget)
    local entity = readEntity(target)
    if entity == nil then
        lastPreHitTarget = 0
        return
    end

    local firstFrameForTarget = target ~= lastPreHitTarget
    local registered = registerCandidate(
        target,
        "pre-hit Sora+0x74(compressed)",
        true
    )
    if not registered then
        return
    end

    if firstFrameForTarget then
        record(string.format(
            "PRE-HIT LIVE TARGET ACTIVE tick=%d object=%s "
                .. "stat_page=%s encoded=0x%08X native_HP=%u/%u "
                .. "source=Sora+0x74(compressed)",
            tick,
            pointerText(entity.object),
            pointerText(entity.statPage),
            entity.encodedStatPage,
            entity.hp,
            entity.maxHp
        ), true)
        saveReport()
    end
    lastPreHitTarget = target
end

local function processCapturedDamageTarget()
    local target = safeReadLong(HOOK_LAST_DAMAGE_TARGET_RVA) or 0
    if target == 0 then
        return
    end

    local cleared, clearReason = safeWritePointer(
        HOOK_LAST_DAMAGE_TARGET_RVA,
        0
    )
    if not cleared then
        record(
            "NATIVE DAMAGE CAPTURE DISABLED: could not clear capture slot: "
                .. tostring(clearReason),
            true
        )
        return
    end
    capturedDamageSequence = capturedDamageSequence + 1

    local entity = readEntity(target)
    if entity == nil then
        record(string.format(
            "NATIVE DAMAGE TARGET REJECTED tick=%d event=%u "
                .. "object=%s reason=no-valid-live-stat-page",
            tick,
            capturedDamageSequence,
            pointerText(target)
        ), true)
        return
    end

    local matchedSource = nil
    local lockOnTargets = collectLiveLockOnTargets()
    for _, lockOn in ipairs(lockOnTargets) do
        if lockOn.address == target then
            matchedSource = lockOn.source
            break
        end
    end

    if matchedSource == nil then
        local rejectedKey = addressKey(target)
        if not rejectedDamageEvents[rejectedKey] then
            rejectedDamageEvents[rejectedKey] = true
            record(string.format(
                "NATIVE DAMAGE TARGET REJECTED tick=%d event=%u "
                    .. "object=%s stat_page=%s HP=%u/%u "
                    .. "reason=not-current-lock-on-target lock_candidates=%u",
                tick,
                capturedDamageSequence,
                pointerText(target),
                pointerText(entity.statPage),
                entity.hp,
                entity.maxHp,
                #lockOnTargets
            ), true)
        end
        return
    end

    local existing = candidates[addressKey(entity.statPage)]
    local previousHp = existing ~= nil and existing.hp or nil
    local activeProfile = existing ~= nil and existing.profile or nil
    if activeProfile == nil
        and SETTINGS.ENABLE_CONFIRMED_TARGET_FALLBACK
    then
        activeProfile = CONFIRMED_TARGET_FALLBACK_PROFILE
    end
    local configuredMultiplier = activeProfile ~= nil
        and profileDamageTakenMultiplier(activeProfile)
        or SETTINGS.GLOBAL.DAMAGE_TAKEN_MULTIPLIER
    local publishedMultiplier, publishedSlot =
        publishedDamageTakenMultiplier(entity.encodedStatPage)
    publishedMultiplier = publishedMultiplier or 1.0
    local observedLoss = "unavailable"
    if previousHp ~= nil and previousHp >= entity.hp then
        observedLoss = tostring(previousHp - entity.hp)
    end

    record(string.format(
        "NATIVE DAMAGE TARGET CONFIRMED tick=%d event=%u "
            .. "object=%s stat_page=%s encoded=0x%08X HP=%u/%u "
            .. "lock_source=%s previous_HP=%s observed_HP_loss=%s "
            .. "configured_damage_taken=%.3f published_damage_taken=%.3f "
            .. "published_slot=%s hook_match=%s",
        tick,
        capturedDamageSequence,
        pointerText(target),
        pointerText(entity.statPage),
        entity.encodedStatPage,
        entity.hp,
        entity.maxHp,
        matchedSource,
        tostring(previousHp),
        observedLoss,
        configuredMultiplier,
        publishedMultiplier,
        publishedSlot >= 0 and tostring(publishedSlot) or "default",
        tostring(
            math.abs(configuredMultiplier - publishedMultiplier) <= 0.0001
        )
    ), true)
    registerCandidate(
        target,
        "native-final-HP + " .. matchedSource,
        true
    )
    saveReport()
end

-- =========================================================================
-- LIVE ENTITY GRAPH DISCOVERY
-- =========================================================================

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
    registerCandidate(address, source, false)
    enqueueNode(address, depth, source)
end

local function scanNode(node)
    registerCandidate(node.address, node.source)
    if node.depth >= 2 then
        return
    end

    local scanLength = node.depth == 0 and 0x800 or 0x300
    local bytes = safeReadArray(node.address, scanLength, true)
    if bytes == nil then
        return
    end

    for byteOffset = 0, scanLength - 4, 4 do
        local value32 = bytesU32(bytes, byteOffset + 1)
        local fieldSource = string.format(
            "%s+0x%03X",
            pointerText(node.address),
            byteOffset
        )
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

        if byteOffset % 8 == 0 and byteOffset <= scanLength - 8 then
            local value64 = bytesU64(bytes, byteOffset + 1)
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

local function seedGraph()
    if currentSora ~= 0 then
        enqueueNode(currentSora, 0, "Sora root")
    end

    local nativeSora = safeReadLong(NATIVE_RAGNAROK_SORA_POINTER)
    if nativeSora ~= nil and nativeSora ~= 0 then
        enqueueNode(nativeSora, 0, "native-Sora root")
    end
end

local function restartGraph()
    graphQueue = {}
    graphQueueHead = 1
    graphQueued = {}
    graphScanned = {}
    graphNodesQueued = 0
    lastGraphRestartTick = tick
    seedGraph()
end

local function processGraph()
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
        restartGraph()
    end
end

local function processNarrowGlobalProbe()
    for _ = 1, TARGET_GLOBAL_SLOTS_PER_TICK do
        local offset = TARGET_GLOBAL_SCAN_START + globalScanOffset
        local direct = safeReadLong(offset)
        if direct ~= nil then
            registerCandidate(
                direct,
                string.format("module+0x%X(direct64)", offset)
            )
        end

        local encoded = safeReadInt(offset)
        if encoded ~= nil and encoded >= 0x80000000 then
            registerCandidate(
                resolveCompressedPointer(encoded),
                string.format("module+0x%X(compressed32)", offset)
            )
        end

        globalScanOffset = globalScanOffset + 4
        if globalScanOffset >= TARGET_GLOBAL_SCAN_LENGTH then
            globalScanOffset = 0
        end
    end
end

local function resetDiscovery(newSora)
    currentSora = newSora or 0
    lastPreHitTarget = 0
    candidates = {}
    candidateOrder = {}
    candidateCount = 0
    globalScanOffset = 0
    lastOverflowCount = -1
    restartGraph()
    record(string.format(
        "DISCOVERY RESET tick=%d Sora=%s",
        tick,
        pointerText(currentSora)
    ), false)
end

-- =========================================================================
-- DAMAGE HOOK INSTALLATION AND LIVE TARGET TABLE
-- =========================================================================

local function validateExecutable()
    if not arraysEqual(
        safeReadArray(FINAL_HP_ADJUST_RVA, #FINAL_HP_ADJUST_SIGNATURE),
        FINAL_HP_ADJUST_SIGNATURE
    ) then
        return false, "final HP-adjust function signature mismatch"
    end

    if not arraysEqual(
        safeReadArray(POINTER_RESOLVER_RVA, #POINTER_RESOLVER_SIGNATURE),
        POINTER_RESOLVER_SIGNATURE
    ) then
        return false, "compressed-pointer resolver signature mismatch"
    end

    return true
end

local function installDamageHook()
    local callsite = safeReadArray(
        HOOK_CALLSITE_RVA,
        #HOOK_CALLSITE_ORIGINAL
    )
    local cave = safeReadArray(HOOK_CAVE_RVA, HOOK_CAVE_SIZE)
    if callsite == nil or cave == nil then
        return false, "hook memory could not be read"
    end

    local ownHook = arraysEqual(
        cave,
        HOOK_CAVE_TEMPLATE,
        HOOK_CODE_PREFIX_SIZE
    )
    local legacyHook = arraysEqual(
        cave,
        V1_5_HOOK_CAVE_BYTES,
        0x5C
    )
    local v19Hook = arraysEqual(
        cave,
        V19_HOOK_CAVE_BYTES,
        #V19_HOOK_CAVE_BYTES
    )

    if arraysEqual(callsite, HOOK_CALLSITE_PATCH) then
        if not ownHook and not legacyHook and not v19Hook then
            return false, "HP hook call exists but the cave belongs to an unknown script"
        end
    elseif arraysEqual(callsite, HOOK_CALLSITE_ORIGINAL) then
        if not isZeroArray(cave) then
            return false, "HP hook site is original but its private cave is not empty"
        end
    else
        return false, "HP hook callsite is neither original nor compatible"
    end

    local caveOK, caveReason = safeWriteArray(
        HOOK_CAVE_RVA,
        HOOK_CAVE_TEMPLATE,
        false
    )
    if not caveOK then
        return false, "enemy-stat cave install failed: " .. caveReason
    end

    if not arraysEqual(callsite, HOOK_CALLSITE_PATCH) then
        local callOK, callReason = safeWriteArray(
            HOOK_CALLSITE_RVA,
            HOOK_CALLSITE_PATCH,
            false
        )
        if not callOK then
            return false, "enemy-stat hook call failed: " .. callReason
        end
    end

    local sinkOK, sinkReason = safeWriteFloat(
        V19_COMPATIBILITY_SINK_RVA,
        1.0,
        false
    )
    if not sinkOK then
        return false, "v19 compatibility sink failed: " .. sinkReason
    end

    return true, ownHook
        and "reused the existing v2 enemy-stat hook"
        or (
            legacyHook
            and "replaced the false-target v1.x hook"
            or (
                v19Hook
                and "replaced the compatible v19 hook"
                or "installed the v2 enemy-stat hook"
            )
        )
end

local function ownHookStillInstalled()
    local prefix = safeReadArray(
        HOOK_CAVE_RVA,
        HOOK_CODE_PREFIX_SIZE
    )
    return arraysEqual(
        prefix,
        HOOK_CAVE_TEMPLATE,
        HOOK_CODE_PREFIX_SIZE
    )
end

local function candidateIsLive(candidate)
    if candidate == nil or candidate.profile == nil
        or not candidate.confirmedCombatTarget
        or candidate.profile.enabled == false
    then
        return false
    end

    local hp = safeReadInt(
        candidate.statPage + STAT_CURRENT_HP_OFFSET,
        true
    )
    local maxHp = safeReadInt(
        candidate.statPage + STAT_MAX_HP_OFFSET,
        true
    )
    return hp ~= nil and maxHp ~= nil
        and hp > 0 and maxHp > 0 and hp <= maxHp
        and maxHp <= MAX_HP_STORAGE_VALUE
end

local function updateDamageHookState()
    local pointerOK, pointerReason = safeWritePointer(
        HOOK_SORA_RVA,
        currentSora
    )
    if not pointerOK then
        return false, "Sora pointer update failed: " .. pointerReason
    end

    -- Unmatched non-Sora targets remain at 1.0 so party members and NPCs
    -- cannot be scaled accidentally.
    local defaultOK, defaultReason = safeWriteFloat(
        HOOK_DEFAULT_TAKEN_RVA,
        1.0,
        false
    )
    if not defaultOK then
        return false, "default target multiplier failed: " .. defaultReason
    end

    local dealtOK, dealtReason = safeWriteFloat(
        HOOK_DEFAULT_DEALT_RVA,
        SETTINGS.GLOBAL.DAMAGE_DEALT_MULTIPLIER,
        false
    )
    if not dealtOK then
        return false, "damage-dealt multiplier failed: " .. dealtReason
    end

    -- Clear IDs first, write multipliers second, publish IDs last.
    for slot = 0, HOOK_TARGET_SLOT_COUNT - 1 do
        local slotAddress = HOOK_TARGET_TABLE_RVA
            + slot * HOOK_TARGET_SLOT_SIZE
        local clearOK, clearReason = safeWriteInt(
            slotAddress,
            0,
            false
        )
        if not clearOK then
            return false, "target-table clear failed: " .. clearReason
        end
    end

    local liveTargets = {}
    for _, key in ipairs(candidateOrder) do
        local candidate = candidates[key]
        if candidateIsLive(candidate) then
            local multiplier = profileDamageTakenMultiplier(
                candidate.profile
            )
            if math.abs(multiplier - 1.0) > 0.0001 then
                liveTargets[#liveTargets + 1] = {
                    encoded = candidate.encodedStatPage,
                    multiplier = multiplier,
                    name = candidate.profile.name,
                }
            end
        end
    end

    local slotCount = math.min(
        #liveTargets,
        HOOK_TARGET_SLOT_COUNT
    )
    for index = 1, slotCount do
        local target = liveTargets[index]
        local slotAddress = HOOK_TARGET_TABLE_RVA
            + (index - 1) * HOOK_TARGET_SLOT_SIZE
        local multiplierOK, multiplierReason = safeWriteFloat(
            slotAddress + 4,
            target.multiplier,
            false
        )
        if not multiplierOK then
            return false, "target multiplier failed: " .. multiplierReason
        end
    end
    for index = 1, slotCount do
        local target = liveTargets[index]
        local slotAddress = HOOK_TARGET_TABLE_RVA
            + (index - 1) * HOOK_TARGET_SLOT_SIZE
        local idOK, idReason = safeWriteInt(
            slotAddress,
            target.encoded,
            false
        )
        if not idOK then
            return false, "target ID publish failed: " .. idReason
        end
    end

    local routeParts = {}
    for index = 1, slotCount do
        local target = liveTargets[index]
        routeParts[#routeParts + 1] = string.format(
            "%08X:%.4f:%s",
            target.encoded,
            target.multiplier,
            target.name
        )
    end
    local routeKey = table.concat(routeParts, "|")
    if routeKey ~= damageRouteLogKey then
        damageRouteLogKey = routeKey
        if slotCount == 0 then
            record(
                "DAMAGE ROUTE NATIVE tick=" .. tostring(tick)
                    .. " no confirmed target currently requests scaled damage",
                false
            )
        else
            for index = 1, slotCount do
                local target = liveTargets[index]
                record(string.format(
                    "DAMAGE ROUTE ACTIVE tick=%d slot=%d enemy=%s "
                        .. "encoded=0x%08X damage_taken_multiplier=%.3f",
                    tick,
                    index - 1,
                    target.name,
                    target.encoded,
                    target.multiplier
                ), true)
            end
        end
    end

    local overflow = math.max(0, #liveTargets - HOOK_TARGET_SLOT_COUNT)
    if overflow ~= lastOverflowCount then
        lastOverflowCount = overflow
        if overflow > 0 then
            record(string.format(
                "TARGET TABLE OVERFLOW tick=%d live_scaled_targets=%d "
                    .. "capacity=%d overflow=%d; overflow targets remain at 1.0",
                tick,
                #liveTargets,
                HOOK_TARGET_SLOT_COUNT,
                overflow
            ), true)
        end
    end

    return true
end

-- =========================================================================
-- PUBLIC CALLBACKS
-- =========================================================================

function SETTINGS._combinedStatsInit()
    enabled = false
    tick = 0
    currentSora = 0
    capturedDamageSequence = 0
    rejectedDamageEvents = {}
    lastPreHitTarget = 0
    reportLines = {}
    reportDirty = false
    lastReportSaveTick = 0
    healthBaselines = {}
    identifiedLogged = {}
    unresolvedLogged = {}
    motionObservedLogged = {}
    lastOverflowCount = -1
    damageRouteLogKey = nil

    record("KH1FM All Enemy Stats + Speed + Themes v2.2 / Stats report", false)
    record("Target: Steam Global 1.0.0.2 family / LuaBackendHook v1.9.1-hook", false)
    record(string.format(
        "Global settings: max_hp=%s HP_multiplier=%.3f "
            .. "damage_taken=%.3f damage_dealt=%.3f",
        tostring(SETTINGS.GLOBAL.MAX_HP),
        SETTINGS.GLOBAL.HP_MULTIPLIER,
        SETTINGS.GLOBAL.DAMAGE_TAKEN_MULTIPLIER,
        SETTINGS.GLOBAL.DAMAGE_DEALT_MULTIPLIER
    ), false)
    record(string.format(
        "Fallback settings: enabled=%s max_hp=%s HP_multiplier=%s "
            .. "damage_taken=%s overall_speed=%s animation_speed_ids=%u "
            .. "confirmed_target_fallback=%s",
        tostring(SETTINGS.CONFIRMED_TARGET_FALLBACK.enabled ~= false),
        tostring(SETTINGS.CONFIRMED_TARGET_FALLBACK.max_hp),
        tostring(SETTINGS.CONFIRMED_TARGET_FALLBACK.hp_multiplier),
        tostring(SETTINGS.CONFIRMED_TARGET_FALLBACK.damage_taken_multiplier),
        tostring(
            SETTINGS.CONFIRMED_TARGET_FALLBACK.overall_speed_multiplier
        ),
        #SETTINGS.CONFIRMED_TARGET_FALLBACK.safe_speed_animations,
        tostring(SETTINGS.ENABLE_CONFIRMED_TARGET_FALLBACK)
    ), false)
    record(string.format(
        "Configured speed engine: animation_enabled=%s "
            .. "world_movement_enabled=%s native_default=%.3f "
            .. "allow_unidentified=%s max=10.000 motion_logging=%s "
            .. "movement_axis=X/Z warp_limit=%.3f transform_copies=%u",
        tostring(SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.ENABLE),
        tostring(
            SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
                .SCALE_WORLD_MOVEMENT
        ),
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.GLOBAL_MULTIPLIER,
        tostring(
            SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
                .ALLOW_CONFIRMED_TARGET_FALLBACK
        ),
        tostring(
            SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.LOG_OBSERVED_ANIMATIONS
        ),
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .MAX_HORIZONTAL_DELTA_PER_TICK,
        #SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
            .POSITION_VECTOR_OFFSETS
    ), false)

    if not SETTINGS.ENABLE then
        record("DISABLED: SETTINGS.ENABLE is false.", true)
        saveReport()
        return
    end

    local settingsOK, settingsReason = buildProfileLookups()
    if not settingsOK then
        record("DISABLED: " .. settingsReason .. ".", true)
        saveReport()
        return
    end
    record(string.format(
        "Unique fingerprint bindings active: %u; "
            .. "target-context fallbacks active: %u; "
            .. "current world=%s room=%s",
        SHARED.UNIQUE_FINGERPRINT_COUNT or 0,
        #targetContextProfileBindings,
        tostring(safeReadByte(WORLD_ADDRESS)),
        tostring(safeReadByte(ROOM_ADDRESS))
    ), false)

    for _, warning in ipairs(profileWarnings) do
        record("PROFILE WARNING: " .. warning, true)
    end

    local executableOK, executableReason = validateExecutable()
    if not executableOK then
        record("DISABLED: " .. executableReason .. ".", true)
        saveReport()
        return
    end

    local hookOK, hookReason = installDamageHook()
    if not hookOK then
        record("DISABLED: " .. hookReason .. ".", true)
        saveReport()
        return
    end

    pcall(SetHertz, 60)
    restartGraph()
    enabled = true

    record("READY: " .. hookReason .. ".", true)
    record(
        "HP and damage-taken settings activate from the verified pre-hit Sora+0x74 live target.",
        true
    )
    record(
        "HP baseline is keyed to the live stat page and ignores wrapper/fingerprint churn while the last applied maximum remains present.",
        true
    )
    record(
        "Native final-HP capture remains enabled for post-hit target corroboration.",
        true
    )
    record(
        "Exact HP precedence: profile exact, profile multiplier, global exact, global multiplier.",
        true
    )
    record(
        "Named row values activate after model-code or unique-fingerprint identification across rooms; target-context is a fallback and unmapped targets use CONFIRMED_TARGET_FALLBACK.",
        true
    )
    record(
        SETTINGS.EXPERIMENTAL_ANIMATION_SPEED.ENABLE
            and (
                SETTINGS.EXPERIMENTAL_ANIMATION_SPEED
                    .ALLOW_CONFIRMED_TARGET_FALLBACK
                and "Configured per-animation/overall speed scales animation and X/Z world movement for named and explicitly enabled fallback targets."
                or "Configured per-animation/overall speed scales animation and X/Z world movement for named targets; unidentified targets remain native."
            )
            or "Experimental speed is read-only; ENEMY MOTION OBSERVED lines perform no writes.",
        true
    )
    record(
        "The former 1/293 +0x2EC fallback is rejected and never modified.",
        true
    )
    record(
        "Other unresolved entities remain report-only.",
        true
    )
    saveReport()
end

function SETTINGS._combinedStatsFrame()
    if not enabled then
        return
    end

    tick = tick + 1

    if tick % 120 == 0 and not ownHookStillInstalled() then
        enabled = false
        record(
            "DISABLED: another script replaced the enemy-stat damage hook after initialization.",
            true
        )
        saveReport()
        return
    end

    local sora = safeReadLong(SORA_POINTER) or 0
    if sora ~= currentSora then
        resetDiscovery(sora)
    end

    processNarrowGlobalProbe()
    processGraph()
    processPreHitLiveTarget()

    -- Publish the verified pre-hit target before consuming this frame's native
    -- capture so the report can compare the configured and live hook values.
    local hookOK, hookReason = updateDamageHookState()
    if not hookOK then
        enabled = false
        record("DISABLED: " .. hookReason .. ".", true)
        safeWriteFloat(HOOK_DEFAULT_TAKEN_RVA, 1.0, false)
        safeWriteFloat(HOOK_DEFAULT_DEALT_RVA, 1.0, false)
        saveReport()
        return
    end

    processCapturedDamageTarget()
    -- Refresh after captured-damage telemetry so candidate.hp still represents
    -- the previous observed frame when observed_HP_loss is calculated.
    refreshCandidates()
    updateSafeAnimationSpeeds()

    if reportDirty and tick - lastReportSaveTick >= 300 then
        saveReport()
    end
end


    return {
        init = SETTINGS._combinedStatsInit,
        frame = SETTINGS._combinedStatsFrame,
    }
end

local function buildMusicModule(SHARED)
    local SETTINGS = {
        ENABLE = SHARED.ENABLE,
        DEFAULT_THEME = SHARED.MUSIC_DEFAULTS,
        UNMAPPED_LOCK_ON_THEME = SHARED.UNKNOWN_ENEMY_MUSIC,
        ENEMY_THEME_OVERRIDES = {},
        TARGET_CONTEXT_BINDINGS = {},
        UNMAPPED_LOCK_ON_EXCLUSIONS = SHARED.NON_ENEMY_EXCLUSIONS,
        FINGERPRINT_ENEMY_BINDINGS = {},
        ENEMY_MODEL_CODES = {},
        PRESENCE_HOLD_TICKS = SHARED.PRESENCE_HOLD_TICKS,
        AUTO_SLOT1_BONUS_TICKS = SHARED.AUTO_SLOT1_BONUS_TICKS,
        AUTO_SOURCE_WAIT_TICKS = SHARED.AUTO_SOURCE_WAIT_TICKS,
        AUTO_SOURCE_PRE_ROLL_TICKS = SHARED.AUTO_SOURCE_PRE_ROLL_TICKS,
        MAX_TRACKED_BGM_SLOT = SHARED.MAX_TRACKED_BGM_SLOT,
        REPORT_FILENAME = SHARED.MUSIC_REPORT_FILENAME,
        ECHO_ALL_BGM_TO_F2 = SHARED.ECHO_ALL_BGM_TO_F2,
        REPORT_SAVE_INTERVAL_TICKS =
            SHARED.REPORT_SAVE_INTERVAL_TICKS,
        MAX_TIMELINE_ROWS = SHARED.MAX_TIMELINE_ROWS,
    }

    for name, row in pairs(SHARED.ENEMIES) do
        SETTINGS.ENEMY_MODEL_CODES[name] = row.model_codes or {}
        SETTINGS.ENEMY_THEME_OVERRIDES[name] = {
            enabled = row.music_enabled,
            replacement_bgm = row.replacement_bgm,
            source_bgm = row.source_bgm,
            bgm_slot = row.bgm_slot,
            priority = row.music_priority,
        }
        for _, fingerprint in ipairs(row.fingerprints or {}) do
            SETTINGS.FINGERPRINT_ENEMY_BINDINGS[fingerprint] = name
        end
        for _, binding in ipairs(row.context_bindings or {}) do
            SETTINGS.TARGET_CONTEXT_BINDINGS[
                #SETTINGS.TARGET_CONTEXT_BINDINGS + 1
            ] = {
                enemy = name,
                world = binding.world,
                room = binding.room,
                max_hp_values = binding.max_hp_values
                    or { binding.native_max_hp },
                fingerprint = binding.fingerprint,
            }
        end
    end

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

local HOOK_CONTEXT_RVA = 0x000DD6CA
local HOOK_SITE_RVA = 0x000DD6D5
local HOOK_CONTEXT_SIGNATURE = {
    0x48, 0x8D, 0x53, 0x30,
    0x48, 0x8D, 0x0D, 0x1B, 0x55, 0x2D, 0x00,
    0xE8, 0x86, 0x05, 0x04, 0x00,
}
local ORIGINAL_CALL_BYTES = {
    0xE8, 0x86, 0x05, 0x04, 0x00,
}

local BGM_FORMAT_RVA = 0x003B2BF0
local BGM_FORMAT_SIGNATURE = {
    0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x20,
    0x50, 0x6C, 0x61, 0x79, 0x20, 0x42, 0x47, 0x4D,
    0x20, 0x25, 0x73, 0x20, 0x00,
}

local ORIGINAL_DEBUG_RVA = 0x0011DC60
local MUSIC_LIST_HEAD_RVA = 0x004D65D8
SETTINGS._MUSIC_LIST_TAIL_RVA = 0x004D65E0
SETTINGS._MUSIC_LIST_COUNT_RVA = 0x004D65E8
local BGM_STOP_FUNCTION_RVA = 0x000DD7F0
local BGM_STOP_FUNCTION_SIGNATURE = {
    0x40, 0x53, 0x48, 0x83, 0xEC, 0x20,
    0x48, 0x83, 0x3D, 0xDA, 0xD7, 0x0C, 0x02, 0x00,
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
-- BGM HOOK IMAGE AND DATA LAYOUT
-- =========================================================================

-- Verified 181-byte x64 wrapper from Wakka v2.8. The source name, replacement
-- name, route flag, and replacement node all live in writable hook data, so
-- Lua can publish a different route without changing executable code. It records the
-- source/effective names and playback parameters before tail-jumping into the
-- original Panacea-aware debug function.
local HOOK_CODE_HEX =
    "f30f6f02f30f7f0500000000f30f6f4210f30f7f0500000000488b0248"
    .. "3b0500000000750d807a082e750748891d00000000833d00000000007432"
    .. "483b05000000007529807a082e75234c8b15000000004d85d274104c89d3"
    .. "498d5230f0ff0500000000eb07f0ff050000000048891500000000f30f6f"
    .. "02f30f7f0500000000f30f6f4210f30f7f0500000000893500000000f30f"
    .. "113d00000000f30f113500000000892d00000000f0ff0500000000e90000"
    .. "0000"

local HOOK_CODE_SIZE = 0x0B5
local HOOK_CODE_PREFIX = {
    0xF3, 0x0F, 0x6F, 0x02, 0xF3, 0x0F, 0x7F, 0x05,
}

local DATA_SOURCE_BUFFER_OFFSET = 0x000
local DATA_EFFECTIVE_BUFFER_OFFSET = 0x040
local DATA_SOURCE_NAME_OFFSET = 0x080
local DATA_TARGET_NAME_OFFSET = 0x0A0
local DATA_REDIRECT_FLAG_OFFSET = 0x0C8
local DATA_BGM_ID_OFFSET = 0x0CC
local DATA_VOLUME_BITS_OFFSET = 0x0D0
local DATA_FADE_BITS_OFFSET = 0x0D4
local DATA_TIME_OFFSET = 0x0D8
local DATA_REQUEST_COUNTER_OFFSET = 0x0E4
local DATA_REDIRECT_COUNTER_OFFSET = 0x0E8
local DATA_TARGET_MISSING_COUNTER_OFFSET = 0x0EC
local DATA_DISPATCH_FLAG_OFFSET = 0x108
local DATA_DISPATCH_BGM_ID_OFFSET = 0x10C
local DATA_DISPATCH_VOLUME_BITS_OFFSET = 0x110
local DATA_DISPATCH_FADE_BITS_OFFSET = 0x114
local DATA_DISPATCH_TIME_OFFSET = 0x118
local DATA_DISPATCH_COUNTER_OFFSET = 0x11C
local DATA_ORIGINAL_FRAME_POINTER_OFFSET = 0x120
local DATA_FRAME_VTABLE_SLOT_OFFSET = 0x130
local DATA_MAGIC_OFFSET = 0x138
local DATA_TARGET_NODE_OFFSET = 0x148
local DATA_MAGIC = "BGMMUL1\0"
local DATA_SIZE = 0x160

-- Every relocation identifies the disp32 field, the instruction-end RVA
-- used by x64 RIP-relative addressing, and its runtime target.
local RELOCATIONS = {
    { field = 0x008, next = 0x00C, data = DATA_SOURCE_BUFFER_OFFSET },
    { field = 0x015, next = 0x019,
        data = DATA_SOURCE_BUFFER_OFFSET + 0x10 },
    { field = 0x01F, next = 0x023, data = DATA_TARGET_NAME_OFFSET },
    { field = 0x02E, next = 0x032, data = DATA_TARGET_NODE_OFFSET },
    { field = 0x034, next = 0x039, data = DATA_REDIRECT_FLAG_OFFSET },
    { field = 0x03E, next = 0x042, data = DATA_SOURCE_NAME_OFFSET },
    { field = 0x04D, next = 0x051, data = DATA_TARGET_NODE_OFFSET },
    { field = 0x060, next = 0x064, data = DATA_REDIRECT_COUNTER_OFFSET },
    { field = 0x069, next = 0x06D,
        data = DATA_TARGET_MISSING_COUNTER_OFFSET },
    { field = 0x070, next = 0x074, data = 0x0C0 },
    { field = 0x07C, next = 0x080, data = DATA_EFFECTIVE_BUFFER_OFFSET },
    { field = 0x089, next = 0x08D,
        data = DATA_EFFECTIVE_BUFFER_OFFSET + 0x10 },
    { field = 0x08F, next = 0x093, data = DATA_BGM_ID_OFFSET },
    { field = 0x097, next = 0x09B, data = DATA_VOLUME_BITS_OFFSET },
    { field = 0x09F, next = 0x0A3, data = DATA_FADE_BITS_OFFSET },
    { field = 0x0A5, next = 0x0A9, data = DATA_TIME_OFFSET },
    { field = 0x0AC, next = 0x0B0, data = DATA_REQUEST_COUNTER_OFFSET },
}
local ORIGINAL_TARGET_FIELD = 0x0B1
local ORIGINAL_TARGET_NEXT = 0x0B5

-- 103-byte dynamic-slot dispatcher. It consumes a Lua-published one-shot
-- request, stops the published BGM slot, replays that same slot with the last
-- native parameters, and tail-jumps to LuaBackend's original frame hook.
local FRAME_CODE_HEX =
    "514883ec30833d0000000000744bc70500000000000000008b0d00000000"
    .. "e8000000008b0d000000004531c0448b0d00000000f30f100d00000000"
    .. "f30f1015000000004c894424204c89442428e800000000f0ff0500000000"
    .. "488b05000000004883c43059ffe0"
local FRAME_CODE_SIZE = 0x67
local FRAME_CODE_PREFIX = {
    0x51, 0x48, 0x83, 0xEC, 0x30,
}
local FRAME_RELOCATIONS = {
    { field = 0x007, next = 0x00C, data = DATA_DISPATCH_FLAG_OFFSET },
    { field = 0x010, next = 0x018, data = DATA_DISPATCH_FLAG_OFFSET },
    { field = 0x01A, next = 0x01E, data = DATA_DISPATCH_BGM_ID_OFFSET },
    { field = 0x01F, next = 0x023, absolute = BGM_STOP_FUNCTION_RVA },
    { field = 0x025, next = 0x029, data = DATA_DISPATCH_BGM_ID_OFFSET },
    { field = 0x02F, next = 0x033, data = DATA_DISPATCH_TIME_OFFSET },
    { field = 0x037, next = 0x03B,
        data = DATA_DISPATCH_VOLUME_BITS_OFFSET },
    { field = 0x03F, next = 0x043,
        data = DATA_DISPATCH_FADE_BITS_OFFSET },
    { field = 0x04E, next = 0x052, absolute = BGM_FUNCTION_RVA },
    { field = 0x055, next = 0x059, data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x05C, next = 0x060,
        data = DATA_ORIGINAL_FRAME_POINTER_OFFSET },
}
local COMBINED_CODE_SIZE = HOOK_CODE_SIZE + FRAME_CODE_SIZE

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
SETTINGS._runtime = {
    modelCodeProfiles = {},
    fingerprintProfiles = {},
    contextBindings = {},
    fallbackExclusions = {},
    evidence = {},
    publishedPresence = {},
    activeEnemy = nil,
    activeProfile = nil,
    activeMatchSource = nil,
    routeLatched = false,
    routeWorld = nil,
    routeRoom = nil,
    routeSource = nil,
    routeReplacement = nil,
    routeSlot = nil,
    redirectFlagPublished = -1,
    activeSwitchQueued = false,
    activeSwitchAttempted = false,
    slotBgm = {},
    preservedNodes = {},
    lastNodeScanTick = {},
    missingNodeReported = {},
    fallbackExclusionReported = {},
    currentEffectiveBgm = nil,
}

local graphQueue = {}
local graphQueueHead = 1
local graphQueued = {}
local graphScanned = {}
local graphNodesQueued = 0
local lastGraphRestartTick = -100000
local globalScanOffset = 0

local lastRequestCounter = 0
local lastRedirectCounter = 0
local lastTargetMissingCounter = 0
local lastDispatchCounter = 0
local totalRequests = 0
local totalRedirects = 0
local totalTargetMissing = 0
local totalActiveSwitches = 0
local timelineRows = {}
local timelineCapped = false
local statusLines = {}
local reportDirty = false
local lastReportSaveTick = 0

-- =========================================================================
-- LOGGING AND REPORT
-- =========================================================================

local function console(message)
    ConsolePrint("[AllEnemyStatsSpeedThemesV2:Music] " .. message)
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
    local runtime = SETTINGS._runtime
    local preservedCount = 0
    for _ in pairs(runtime.preservedNodes) do
        preservedCount = preservedCount + 1
    end
    local lines = {
        "KH1FM All Enemy Stats + Speed + Themes v2 / Music report",
        "Target: KINGDOM HEARTS FINAL MIX.exe / Steam Global 1.0.0.2",
        "Named enemy profiles: " .. tostring(SETTINGS._profileCount or 0),
        "Default replacement BGM: "
            .. tostring(SETTINGS.DEFAULT_THEME.replacement_bgm),
        "Detection: named model code or verified context binding.",
        "Unmapped lock-on fallback: disabled.",
        "Late detection: the selected already-playing BGM slot is switched on the next frame.",
        "Wakka override: music119.win32.scd on slot 1.",
        "",
        "SUMMARY",
        string.format("BGM requests observed: %u", totalRequests),
        string.format("BGM redirects completed: %u", totalRedirects),
        string.format(
            "Already-playing BGM switches executed: %u",
            totalActiveSwitches
        ),
        string.format("Replacement-node lookup failures: %u", totalTargetMissing),
        "Preserved replacement nodes: " .. tostring(preservedCount),
        "Active enemy: " .. tostring(runtime.activeEnemy or "none"),
        "Active match source: "
            .. tostring(runtime.activeMatchSource or "none"),
        "Encounter route latched: " .. tostring(runtime.routeLatched),
        "Routed slot: " .. tostring(runtime.routeSlot or "none"),
        "Routed source/replacement BGM: "
            .. tostring(runtime.routeSource or "<none>")
            .. " / "
            .. tostring(runtime.routeReplacement or "<none>"),
        "Current/last effective BGM: "
            .. tostring(runtime.currentEffectiveBgm or "<none observed>"),
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

local function cleanFixedString(value)
    if value == nil then
        return ""
    end
    local nul = string.find(value, "\0", 1, true)
    if nul ~= nil then
        return string.sub(value, 1, nul - 1)
    end
    return value
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

local function makeCallPatch(callRva, targetRva)
    local displacement = rel32(targetRva, callRva + 5)
    if displacement == nil then
        return nil
    end
    local patch = { 0xE8, 0, 0, 0, 0 }
    putU32(patch, 1, displacement)
    return patch
end

local function buildHookCode()
    local code = bytesFromHex(HOOK_CODE_HEX)
    if #code ~= HOOK_CODE_SIZE then
        return nil, "embedded hook size mismatch"
    end
    for _, relocation in ipairs(RELOCATIONS) do
        local target = relocation.absolute
            or (dataRva + relocation.data)
        local displacement = rel32(
            target,
            codeRva + relocation.next
        )
        if displacement == nil then
            return nil, "hook rel32 target is out of range"
        end
        putU32(code, relocation.field, displacement)
    end
    local targetDisplacement = rel32(
        ORIGINAL_DEBUG_RVA,
        codeRva + ORIGINAL_TARGET_NEXT
    )
    if targetDisplacement == nil then
        return nil, "original debug target is out of rel32 range"
    end
    putU32(code, ORIGINAL_TARGET_FIELD, targetDisplacement)
    return code
end

local function buildFrameCode()
    local code = bytesFromHex(FRAME_CODE_HEX)
    if #code ~= FRAME_CODE_SIZE then
        return nil, "embedded frame-dispatch size mismatch"
    end
    for _, relocation in ipairs(FRAME_RELOCATIONS) do
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
        (
            SETTINGS.ENEMY_THEME_OVERRIDES["Wakka"] or {}
        ).source_bgm
            or "music000.win32.scd"
    )
    putString(
        data,
        DATA_TARGET_NAME_OFFSET,
        0x20,
        SETTINGS.DEFAULT_THEME.replacement_bgm
    )
    putU32(data, 0x0F0, HOOK_SITE_RVA)
    putU32(data, 0x0F4, codeRva)
    putU32(data, 0x0F8, ORIGINAL_DEBUG_RVA)
    putU32(data, 0x0FC, HOOK_CODE_SIZE)
    putU32(data, 0x100, DATA_SIZE)
    putU64(
        data,
        DATA_ORIGINAL_FRAME_POINTER_OFFSET,
        originalFramePointer
    )
    putU32(data, 0x128, frameCodeRva)
    putU32(data, 0x12C, FRAME_CODE_SIZE)
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
    if not arraysEqual(
        safeReadArray(HOOK_CONTEXT_RVA, #HOOK_CONTEXT_SIGNATURE),
        HOOK_CONTEXT_SIGNATURE
    ) then
        local currentCall =
            safeReadArray(HOOK_SITE_RVA, #ORIGINAL_CALL_BYTES)
        if currentCall ~= nil and currentCall[1] == 0xE8 then
            return false,
                "BGM site is already owned by another recorder/changer; "
                    .. "remove v8 and fully restart the game"
        end
        return false, "verified BGM hook context does not match"
    end

    local occupied = {
        {
            first = HOOK_SITE_RVA,
            last = HOOK_SITE_RVA + #ORIGINAL_CALL_BYTES,
        },
    }
    codeRva = findRawPaddingCave(
        COMBINED_CODE_SIZE,
        16,
        true,
        false,
        occupied
    )
    if codeRva == nil then
        return false,
            "no safe executable cave was available for the packed "
                .. tostring(COMBINED_CODE_SIZE)
                .. "-byte BGM/frame code"
    end
    frameCodeRva = codeRva + HOOK_CODE_SIZE
    occupied[#occupied + 1] = {
        first = codeRva,
        last = codeRva + COMBINED_CODE_SIZE,
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

    local code, codeReason = buildHookCode()
    if code == nil then
        return false, codeReason
    end
    local frameCode, frameCodeReason = buildFrameCode()
    if frameCode == nil then
        return false, frameCodeReason
    end
    local data = buildHookData()
    local patch = makeCallPatch(HOOK_SITE_RVA, codeRva)
    if patch == nil then
        return false, "BGM hook-site target is out of rel32 range"
    end

    local ok
    local reason
    ok, reason = writeArrayChecked(dataRva, data)
    if not ok then
        return false, "hook data install failed: " .. reason
    end
    ok, reason = writeArrayChecked(codeRva, code)
    if not ok then
        return false, "hook code install failed: " .. reason
    end
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "frame-dispatch install failed: " .. reason
    end
    ok, reason = writeArrayChecked(HOOK_SITE_RVA, patch)
    if not ok then
        return false, "BGM hook-site patch failed: " .. reason
    end
    return true, string.format(
        "installed packed multi-enemy BGM route and frame dispatch "
            .. "site=0x%X code=0x%X frame_code=0x%X "
            .. "combined_size=%u data=0x%X",
        HOOK_SITE_RVA,
        codeRva,
        frameCodeRva,
        COMBINED_CODE_SIZE,
        dataRva
    )
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
    local expectedPatch = makeCallPatch(HOOK_SITE_RVA, codeRva)
    return expectedPatch ~= nil
        and arraysEqual(
            safeReadArray(HOOK_SITE_RVA, #expectedPatch),
            expectedPatch
        )
        and arraysEqual(
            safeReadArray(codeRva, #HOOK_CODE_PREFIX),
            HOOK_CODE_PREFIX
        )
        and arraysEqual(
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
-- MULTI-ENEMY IDENTIFICATION
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

function SETTINGS._validBgmName(name)
    return type(name) == "string"
        and string.len(name) < 0x20
        and string.match(name, "^music%d%d%d%.win32%.scd$") ~= nil
end

function SETTINGS._compileProfiles()
    local runtime = SETTINGS._runtime
    runtime.modelCodeProfiles = {}
    runtime.fingerprintProfiles = {}
    runtime.contextBindings = {}
    runtime.fallbackExclusions = {}
    runtime.profiles = {}
    SETTINGS._profileCount = 0

    local default = SETTINGS.DEFAULT_THEME
    if type(default) ~= "table"
        or type(SETTINGS.ENEMY_MODEL_CODES) ~= "table"
        or type(SETTINGS.ENEMY_THEME_OVERRIDES) ~= "table"
        or type(SETTINGS.FINGERPRINT_ENEMY_BINDINGS) ~= "table"
        or type(SETTINGS.TARGET_CONTEXT_BINDINGS) ~= "table"
        or type(SETTINGS.UNMAPPED_LOCK_ON_EXCLUSIONS) ~= "table"
        or type(SETTINGS.MAX_TRACKED_BGM_SLOT) ~= "number"
        or SETTINGS.MAX_TRACKED_BGM_SLOT < 0
        or SETTINGS.MAX_TRACKED_BGM_SLOT > 15
        or SETTINGS.MAX_TRACKED_BGM_SLOT
            ~= math.floor(SETTINGS.MAX_TRACKED_BGM_SLOT)
        or type(SETTINGS.PRESENCE_HOLD_TICKS) ~= "number"
        or SETTINGS.PRESENCE_HOLD_TICKS < 1
        or type(SETTINGS.AUTO_SOURCE_WAIT_TICKS) ~= "number"
        or SETTINGS.AUTO_SOURCE_WAIT_TICKS < 0
        or type(SETTINGS.AUTO_SOURCE_PRE_ROLL_TICKS) ~= "number"
        or SETTINGS.AUTO_SOURCE_PRE_ROLL_TICKS < 0
        or type(default.enabled) ~= "boolean"
        or not SETTINGS._validBgmName(default.replacement_bgm)
        or default.source_bgm ~= nil
            and not SETTINGS._validBgmName(default.source_bgm)
        or default.source_bgm ~= nil
            and string.sub(default.source_bgm, 1, 8)
                == string.sub(default.replacement_bgm, 1, 8)
        or default.bgm_slot ~= nil
            and (
                type(default.bgm_slot) ~= "number"
                or default.bgm_slot < 0
                or default.bgm_slot > SETTINGS.MAX_TRACKED_BGM_SLOT
                or default.bgm_slot ~= math.floor(default.bgm_slot)
            )
        or type(default.priority) ~= "number"
    then
        return false, "DEFAULT_THEME is invalid"
    end

    local function makeProfile(name, codes, override)
        override = override or {}
        local profile = {
            name = name,
            enabled = override.enabled,
            replacement_bgm = override.replacement_bgm
                or default.replacement_bgm,
            source_bgm = override.source_bgm ~= nil
                and override.source_bgm or default.source_bgm,
            bgm_slot = override.bgm_slot ~= nil
                and override.bgm_slot or default.bgm_slot,
            priority = override.priority ~= nil
                and override.priority or default.priority,
            model_codes = codes,
        }
        if profile.enabled == nil then
            profile.enabled = default.enabled
        end
        if type(profile.enabled) ~= "boolean"
            or not SETTINGS._validBgmName(profile.replacement_bgm)
            or profile.source_bgm ~= nil
                and not SETTINGS._validBgmName(profile.source_bgm)
            or profile.source_bgm ~= nil
                and string.sub(profile.source_bgm, 1, 8)
                    == string.sub(profile.replacement_bgm, 1, 8)
            or profile.bgm_slot ~= nil
                and (
                    type(profile.bgm_slot) ~= "number"
                    or profile.bgm_slot < 0
                    or profile.bgm_slot > SETTINGS.MAX_TRACKED_BGM_SLOT
                    or profile.bgm_slot ~= math.floor(profile.bgm_slot)
                )
            or type(profile.priority) ~= "number"
        then
            return nil, "theme row " .. tostring(name) .. " is invalid"
        end
        return profile
    end

    for name, codes in pairs(SETTINGS.ENEMY_MODEL_CODES) do
        if type(name) ~= "string" or type(codes) ~= "table" then
            return false, "ENEMY_MODEL_CODES contains an invalid row"
        end
        local profile, reason = makeProfile(
            name,
            codes,
            SETTINGS.ENEMY_THEME_OVERRIDES[name]
        )
        if profile == nil then
            return false, reason
        end
        runtime.profiles[name] = profile
        SETTINGS._profileCount = SETTINGS._profileCount + 1
        for _, code in ipairs(codes) do
            if type(code) ~= "string"
                or string.match(
                    string.lower(code),
                    "^xa_[a-z0-9][a-z0-9]_%d%d%d%d$"
                ) == nil
            then
                return false, "enemy " .. name
                    .. " contains invalid model code " .. tostring(code)
            end
            local normalized = string.lower(code)
            local existing = runtime.modelCodeProfiles[normalized]
            if existing ~= nil and existing ~= profile then
                return false, "model code " .. normalized
                    .. " maps to both " .. existing.name
                    .. " and " .. profile.name
            end
            runtime.modelCodeProfiles[normalized] = profile
        end
    end

    for name in pairs(SETTINGS.ENEMY_THEME_OVERRIDES) do
        if runtime.profiles[name] == nil then
            return false, "theme override names unknown enemy " .. tostring(name)
        end
    end

    local fallback = SETTINGS.UNMAPPED_LOCK_ON_THEME
    if type(fallback) ~= "table" then
        return false, "UNMAPPED_LOCK_ON_THEME is not a table"
    end
    local fallbackProfile, fallbackReason =
        makeProfile("Unmapped Lock-On Target", {}, fallback)
    if fallbackProfile == nil then
        return false, fallbackReason
    end
    fallbackProfile.isFallback = true
    runtime.fallbackProfile = fallbackProfile

    for fingerprint, name in pairs(
        SETTINGS.FINGERPRINT_ENEMY_BINDINGS
    ) do
        local profile = runtime.profiles[name]
        if type(fingerprint) ~= "string"
            or fingerprint == ""
            or profile == nil
        then
            return false, "FINGERPRINT_ENEMY_BINDINGS contains an invalid row"
        end
        runtime.fingerprintProfiles[fingerprint] = profile
    end

    for index, binding in ipairs(SETTINGS.TARGET_CONTEXT_BINDINGS) do
        local profile = type(binding) == "table"
            and runtime.profiles[binding.enemy] or nil
        if profile == nil
            or type(binding.world) ~= "number"
            or binding.world < 0 or binding.world > 255
            or binding.world ~= math.floor(binding.world)
            or binding.room ~= nil
                and (
                    type(binding.room) ~= "number"
                    or binding.room < 0 or binding.room > 255
                    or binding.room ~= math.floor(binding.room)
                )
            or type(binding.max_hp_values) ~= "table"
            or #binding.max_hp_values == 0
            or binding.fingerprint ~= nil
                and (
                    type(binding.fingerprint) ~= "string"
                    or binding.fingerprint == ""
                )
        then
            return false, "target context binding "
                .. tostring(index) .. " is invalid"
        end
        local maxValues = {}
        for _, value in ipairs(binding.max_hp_values) do
            if type(value) ~= "number"
                or value < 1
                or value > MAX_HP_STORAGE_VALUE
                or value ~= math.floor(value)
            then
                return false, "target context binding "
                    .. tostring(index) .. " has invalid max HP"
            end
            maxValues[value] = true
        end
        runtime.contextBindings[#runtime.contextBindings + 1] = {
            profile = profile,
            world = binding.world,
            room = binding.room,
            maxValues = maxValues,
            fingerprint = binding.fingerprint,
        }
    end

    for index, exclusion in ipairs(
        SETTINGS.UNMAPPED_LOCK_ON_EXCLUSIONS
    ) do
        if type(exclusion) ~= "table"
            or type(exclusion.label) ~= "string"
            or exclusion.label == ""
            or type(exclusion.world) ~= "number"
            or exclusion.world < 0 or exclusion.world > 255
            or exclusion.world ~= math.floor(exclusion.world)
            or exclusion.room ~= nil
                and (
                    type(exclusion.room) ~= "number"
                    or exclusion.room < 0 or exclusion.room > 255
                    or exclusion.room ~= math.floor(exclusion.room)
                )
            or type(exclusion.max_hp_values) ~= "table"
            or #exclusion.max_hp_values == 0
            or type(exclusion.fingerprint) ~= "string"
            or exclusion.fingerprint == ""
        then
            return false, "unmapped lock-on exclusion "
                .. tostring(index) .. " is invalid"
        end
        local maxValues = {}
        for _, value in ipairs(exclusion.max_hp_values) do
            if type(value) ~= "number"
                or value < 1
                or value > MAX_HP_STORAGE_VALUE
                or value ~= math.floor(value)
            then
                return false, "unmapped lock-on exclusion "
                    .. tostring(index) .. " has invalid max HP"
            end
            maxValues[value] = true
        end
        runtime.fallbackExclusions[
            #runtime.fallbackExclusions + 1
        ] = {
            label = exclusion.label,
            world = exclusion.world,
            room = exclusion.room,
            maxValues = maxValues,
            fingerprint = exclusion.fingerprint,
        }
    end
    return true
end

function SETTINGS._contextProfile(maxHp, fingerprint)
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    for _, binding in ipairs(SETTINGS._runtime.contextBindings) do
        if world == binding.world
            and (binding.room == nil or room == binding.room)
            and binding.maxValues[maxHp]
            and (
                binding.fingerprint == nil
                or binding.fingerprint == fingerprint
            )
        then
            return binding.profile,
                string.format(
                    "context:%02X:%02X:%u:%s",
                    world or 0,
                    room or 0,
                    maxHp,
                    fingerprint or "*"
                )
        end
    end
    return nil, nil
end

function SETTINGS._fallbackExclusion(maxHp, fingerprint)
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    for _, exclusion in ipairs(
        SETTINGS._runtime.fallbackExclusions
    ) do
        if world == exclusion.world
            and (
                exclusion.room == nil
                or room == exclusion.room
            )
            and exclusion.maxValues[maxHp]
            and exclusion.fingerprint == fingerprint
        then
            return exclusion.label
        end
    end
    return nil
end

function SETTINGS._markEnemy(
    profile,
    source,
    object,
    hp,
    maxHp,
    modelCode
)
    local runtime = SETTINGS._runtime
    local previous = runtime.evidence[profile.name]
    runtime.evidence[profile.name] = {
        tick = tick,
        firstTick = previous ~= nil
            and tick - previous.tick <= SETTINGS.PRESENCE_HOLD_TICKS
            and previous.firstTick or tick,
        profile = profile,
        source = source,
        object = object,
        hp = hp,
        maxHp = maxHp,
        modelCode = modelCode,
    }
    if previous == nil
        or tick - previous.tick > SETTINGS.PRESENCE_HOLD_TICKS
    then
        addTimeline(string.format(
            "ENEMY PRESENT tick=%u seconds=%.3f enemy=%s source=%s "
                .. "model=%s object=0x%X HP=%u/%u",
            tick,
            tick / 60,
            profile.name,
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
    local runtime = SETTINGS._runtime
    local profile = modelCode ~= nil
        and runtime.modelCodeProfiles[string.lower(modelCode)] or nil
    local matchSource = profile ~= nil
        and "model_code:" .. modelCode .. " via " .. source or nil

    if profile == nil then
        profile, matchSource = SETTINGS._contextProfile(
            maxHp,
            identity ~= nil and identity.fingerprint or nil
        )
        if profile ~= nil then
            matchSource = matchSource .. " via " .. source
        end
    end

    if profile == nil and identity ~= nil then
        profile = runtime.fingerprintProfiles[identity.fingerprint]
        if profile ~= nil then
            matchSource = "fingerprint:" .. identity.fingerprint
                .. " via " .. source
        end
    end

    local narrowLockOn = source == "Sora+0x74"
        or string.find(source, "lock-on global", 1, true) ~= nil
    local sharedExclusionKey = addressKey(object)
        .. ":" .. addressKey(statPage)
    local fallbackExclusion =
        SHARED._excludedTargets[sharedExclusionKey]
    if profile == nil
        and narrowLockOn
        and fallbackExclusion == nil
        and identity ~= nil
    then
        fallbackExclusion = SETTINGS._fallbackExclusion(
            maxHp,
            identity.fingerprint
        )
        if fallbackExclusion ~= nil then
            SHARED._excludedTargets[sharedExclusionKey] =
                fallbackExclusion
        end
    end
    if profile == nil
        and narrowLockOn
        and fallbackExclusion ~= nil
    then
        local exclusionKey = fallbackExclusion
            .. ":" .. sharedExclusionKey
        if not runtime.fallbackExclusionReported[exclusionKey] then
            runtime.fallbackExclusionReported[exclusionKey] = true
            addTimeline(string.format(
                "FALLBACK BLOCKED tick=%u seconds=%.3f " ..
                    "label=%s source=%s object=0x%X HP=%u/%u",
                tick,
                tick / 60,
                fallbackExclusion,
                source,
                object,
                hp,
                maxHp
            ), true)
        end
    end
    if profile == nil
        and narrowLockOn
        and identity ~= nil
        and fallbackExclusion == nil
        and runtime.fallbackProfile.enabled
    then
        profile = runtime.fallbackProfile
        matchSource = "unmapped live lock-on via " .. source
    end

    if profile ~= nil and profile.enabled then
        SETTINGS._markEnemy(
            profile,
            matchSource or source,
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

function SETTINGS._replacementNodeMatches(node, name)
    if not plausibleRuntimeAddress(node) then
        return false
    end
    for index = 1, 8 do
        if safeReadByte(node + 0x2F + index, true)
            ~= string.byte(name, index)
        then
            return false
        end
    end
    return safeReadByte(node + 0x38, true) == 0x2E
end

function SETTINGS._writeFixedString(offset, capacity, value)
    local bytes = {}
    for index = 1, capacity do
        bytes[index] = 0
    end
    for index = 1, math.min(string.len(value), capacity - 1) do
        bytes[index] = string.byte(value, index)
    end
    return writeArrayChecked(dataRva + offset, bytes)
end

function SETTINGS._ensureReplacementNode(name)
    local runtime = SETTINGS._runtime
    local preserved = runtime.preservedNodes[name]
    if SETTINGS._replacementNodeMatches(preserved or 0, name) then
        local ok, reason = writeLongChecked(
            dataRva + DATA_TARGET_NODE_OFFSET,
            preserved
        )
        if not ok then
            enabled = false
            addStatus(
                "DISABLED: preserved replacement-node publish failed: "
                    .. tostring(reason) .. ".",
                true
            )
            saveReport()
            return false
        end
        runtime.missingNodeReported[name] = nil
        return true
    end

    local lastScan = runtime.lastNodeScanTick[name] or -100000
    if tick - lastScan < 60 then
        return false
    end
    runtime.lastNodeScanTick[name] = tick

    local target =
        safeReadLong(dataRva + DATA_TARGET_NODE_OFFSET) or 0
    if not SETTINGS._replacementNodeMatches(target, name) then
        target = 0
    end
    local node = safeReadLong(MUSIC_LIST_HEAD_RVA) or 0
    for _ = 1, 1024 do
        if not plausibleRuntimeAddress(node) then
            break
        end
        if target == 0
            and SETTINGS._replacementNodeMatches(node, name)
        then
            target = node
        end
        node = safeReadLong(node + 8, true) or 0
    end
    if target == 0 then
        if not runtime.missingNodeReported[name] then
            runtime.missingNodeReported[name] = true
            addTimeline(string.format(
                "ACTIVE SWITCH WAITING tick=%u seconds=%.3f "
                    .. "reason=%s node is not available yet",
                tick,
                tick / 60,
                name
            ), true)
        end
        return false
    end
    return SETTINGS._preserveReplacementNode(name, target)
end

function SETTINGS._preserveReplacementNode(name, target)
    local runtime = SETTINGS._runtime
    if runtime.preservedNodes[name] ~= nil then
        return SETTINGS._ensureReplacementNode(name)
    end
    if not SETTINGS._replacementNodeMatches(target, name) then
        return false
    end

    local head = safeReadLong(MUSIC_LIST_HEAD_RVA) or 0
    local tail =
        safeReadLong(SETTINGS._MUSIC_LIST_TAIL_RVA) or 0
    local count = safeReadInt(SETTINGS._MUSIC_LIST_COUNT_RVA)
    if count == nil or count == 0 then
        return false
    end

    local previous = 0
    local node = head
    for _ = 1, 1024 do
        if node == target then
            break
        end
        if not plausibleRuntimeAddress(node) then
            node = 0
            break
        end
        previous = node
        node = safeReadLong(node + 8, true) or 0
    end
    if node ~= target then
        return false
    end

    local nextNode = safeReadLong(target + 8, true) or 0
    local ok
    local reason
    if previous == 0 then
        ok, reason = writeLongChecked(MUSIC_LIST_HEAD_RVA, nextNode)
    else
        ok, reason =
            writeLongAbsoluteChecked(previous + 8, nextNode)
    end
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: replacement list detachment failed for "
                .. name .. ": "
                .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return false
    end

    if tail == target then
        ok, reason = writeLongChecked(
            SETTINGS._MUSIC_LIST_TAIL_RVA,
            previous
        )
        if not ok then
            enabled = false
            addStatus(
                "DISABLED: replacement tail preservation failed for "
                    .. name .. ": "
                    .. tostring(reason) .. ".",
                true
            )
            saveReport()
            return false
        end
    end

    ok, reason = writeIntChecked(
        SETTINGS._MUSIC_LIST_COUNT_RVA,
        count - 1
    )
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: replacement list-count preservation failed for "
                .. name .. ": "
                .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return false
    end

    ok, reason = writeLongAbsoluteChecked(target + 8, 0)
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: retained-node isolation failed for "
                .. name .. ": "
                .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return false
    end

    ok, reason = writeLongChecked(
        dataRva + DATA_TARGET_NODE_OFFSET,
        target
    )
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: replacement-node publish failed for "
                .. name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return false
    end
    runtime.preservedNodes[name] = target
    runtime.missingNodeReported[name] = nil
    addTimeline(string.format(
        "REPLACEMENT NODE PRESERVED tick=%u seconds=%.3f "
            .. "name=%s node=0x%X previous=0x%X next=0x%X",
        tick,
        tick / 60,
        name,
        target,
        previous,
        nextNode
    ), true)
    return true
end

function SETTINGS._selectActiveEnemy()
    local runtime = SETTINGS._runtime
    local best = nil
    local current = runtime.activeEnemy ~= nil
        and runtime.evidence[runtime.activeEnemy] or nil
    if current ~= nil
        and tick - current.tick <= SETTINGS.PRESENCE_HOLD_TICKS
        and current.profile.enabled
    then
        best = current
    end
    for _, evidence in pairs(runtime.evidence) do
        if tick - evidence.tick <= SETTINGS.PRESENCE_HOLD_TICKS
            and evidence.profile.enabled
            and (
                best == nil
                or evidence.profile.priority > best.profile.priority
            )
        then
            best = evidence
        end
    end
    return best
end

function SETTINGS._chooseRouteSource(profile, evidence)
    local best = nil
    local autoMayUseOldSource = profile.source_bgm ~= nil
        or tick - evidence.firstTick >= SETTINGS.AUTO_SOURCE_WAIT_TICKS
    for slot, record in pairs(SETTINGS._runtime.slotBgm) do
        local slotMatches = profile.bgm_slot == nil
            or slot == profile.bgm_slot
        local sourceMatches = profile.source_bgm == nil
            or record.source == profile.source_bgm
        if slotMatches
            and sourceMatches
            and record.source ~= ""
            and record.source ~= profile.replacement_bgm
            and (
                autoMayUseOldSource
                or record.tick >= evidence.firstTick
                or (
                    slot == 1
                    and record.tick
                        >= evidence.firstTick
                            - SETTINGS.AUTO_SOURCE_PRE_ROLL_TICKS
                )
            )
        then
            local score = record.tick
            if profile.bgm_slot == nil and slot == 1 then
                score = score + SETTINGS.AUTO_SLOT1_BONUS_TICKS
            end
            if best == nil or score > best.score then
                best = {
                    slot = slot,
                    source = record.source,
                    score = score,
                }
            end
        end
    end
    return best
end

function SETTINGS._publishRoute(evidence, route)
    local runtime = SETTINGS._runtime
    local profile = evidence.profile
    local ok
    local reason
    ok, reason = writeIntChecked(
        dataRva + DATA_REDIRECT_FLAG_OFFSET,
        0
    )
    if not ok then
        return false, "route disarm failed: " .. tostring(reason)
    end
    ok, reason = SETTINGS._writeFixedString(
        DATA_SOURCE_NAME_OFFSET,
        0x20,
        route.source
    )
    if not ok then
        return false, "source-name publish failed: " .. tostring(reason)
    end
    ok, reason = SETTINGS._writeFixedString(
        DATA_TARGET_NAME_OFFSET,
        0x20,
        profile.replacement_bgm
    )
    if not ok then
        return false, "replacement-name publish failed: " .. tostring(reason)
    end
    if not SETTINGS._ensureReplacementNode(profile.replacement_bgm) then
        return false, "replacement node is not available yet"
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_BGM_ID_OFFSET,
        route.slot
    )
    if not ok then
        return false, "BGM-slot publish failed: " .. tostring(reason)
    end

    runtime.activeEnemy = profile.name
    runtime.activeProfile = profile
    runtime.activeMatchSource = evidence.source
    runtime.routeLatched = true
    runtime.routeWorld = safeReadByte(WORLD_ADDRESS)
    runtime.routeRoom = safeReadByte(ROOM_ADDRESS)
    runtime.routeSource = route.source
    runtime.routeReplacement = profile.replacement_bgm
    runtime.routeSlot = route.slot
    runtime.redirectFlagPublished = 0
    runtime.activeSwitchQueued = false
    runtime.activeSwitchAttempted = false
    addTimeline(string.format(
        "ENCOUNTER LATCHED tick=%u seconds=%.3f enemy=%s "
            .. "slot=%d source=%s replacement=%s match=%s",
        tick,
        tick / 60,
        profile.name,
        route.slot,
        route.source,
        profile.replacement_bgm,
        evidence.source
    ), true)
    return true
end

function SETTINGS._queueAlreadyPlayingSwitch()
    local runtime = SETTINGS._runtime
    local record = runtime.routeSlot ~= nil
        and runtime.slotBgm[runtime.routeSlot] or nil
    if runtime.activeSwitchAttempted
        or runtime.activeSwitchQueued
        or record == nil
        or record.source ~= runtime.routeSource
        or record.effective ~= runtime.routeSource
    then
        return
    end
    if not SETTINGS._ensureReplacementNode(runtime.routeReplacement) then
        return
    end

    local fields = {
        {
            offset = DATA_DISPATCH_BGM_ID_OFFSET,
            value = runtime.routeSlot,
            name = "BGM slot",
        },
        {
            offset = DATA_DISPATCH_VOLUME_BITS_OFFSET,
            value = record.volumeBits,
            name = "volume",
        },
        {
            offset = DATA_DISPATCH_FADE_BITS_OFFSET,
            value = record.fadeBits,
            name = "fade volume",
        },
        {
            offset = DATA_DISPATCH_TIME_OFFSET,
            value = record.time,
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
        dataRva + DATA_DISPATCH_FLAG_OFFSET,
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
    runtime.activeSwitchAttempted = true
    runtime.activeSwitchQueued = true
    addTimeline(string.format(
        "ACTIVE SWITCH QUEUED tick=%u seconds=%.3f enemy=%s id=%d "
            .. "source=%s replacement=%s volume=%s "
            .. "fade_volume=%s time=%d",
        tick,
        tick / 60,
        runtime.activeEnemy,
        runtime.routeSlot,
        runtime.routeSource,
        runtime.routeReplacement,
        formatFloat(floatFromBits(record.volumeBits)),
        formatFloat(floatFromBits(record.fadeBits)),
        signed32(record.time)
    ), true)
end

function SETTINGS._clearEncounterLatch(reason)
    local runtime = SETTINGS._runtime
    if not runtime.routeLatched then
        return
    end
    addTimeline(string.format(
        "ENCOUNTER LATCH CLEARED tick=%u seconds=%.3f "
            .. "enemy=%s reason=%s",
        tick,
        tick / 60,
        runtime.activeEnemy or "none",
        reason
    ), true)
    runtime.activeEnemy = nil
    runtime.activeProfile = nil
    runtime.activeMatchSource = nil
    runtime.routeLatched = false
    runtime.routeWorld = nil
    runtime.routeRoom = nil
    runtime.routeSource = nil
    runtime.routeReplacement = nil
    runtime.routeSlot = nil
    runtime.activeSwitchAttempted = false
    runtime.activeSwitchQueued = false
    writeIntChecked(dataRva + DATA_DISPATCH_FLAG_OFFSET, 0)
end

function SETTINGS._updatePresenceAndRoute()
    local runtime = SETTINGS._runtime
    local selected = SETTINGS._selectActiveEnemy()
    if runtime.routeLatched then
        local world = safeReadByte(WORLD_ADDRESS)
        local room = safeReadByte(ROOM_ADDRESS)
        local record = runtime.routeSlot ~= nil
            and runtime.slotBgm[runtime.routeSlot] or nil
        if world ~= runtime.routeWorld or room ~= runtime.routeRoom then
            SETTINGS._clearEncounterLatch("world/room changed")
        elseif record ~= nil
            and record.source ~= runtime.routeSource
            and record.source ~= runtime.routeReplacement
        then
            SETTINGS._clearEncounterLatch(
                "routed native BGM changed to " .. record.source
            )
        elseif selected ~= nil
            and selected.profile.name ~= runtime.activeEnemy
            and selected.profile.priority
                > (runtime.activeProfile.priority or 0)
        then
            SETTINGS._clearEncounterLatch(
                "higher-priority enemy appeared: "
                    .. selected.profile.name
            )
        end
    end

    if not runtime.routeLatched and selected ~= nil then
        local route = SETTINGS._chooseRouteSource(
            selected.profile,
            selected
        )
        if route ~= nil then
            local ok, reason = SETTINGS._publishRoute(selected, route)
            if not ok
                and reason ~= "replacement node is not available yet"
            then
                enabled = false
                addStatus("DISABLED: " .. reason .. ".", true)
                saveReport()
                return
            end
        end
    end

    local desiredFlag = runtime.routeLatched and 1 or 0
    if desiredFlag ~= runtime.redirectFlagPublished then
        local ok, reason = writeIntChecked(
            dataRva + DATA_REDIRECT_FLAG_OFFSET,
            desiredFlag
        )
        if not ok then
            enabled = false
            addStatus(
                "DISABLED: route flag write failed: "
                    .. tostring(reason) .. ".",
                true
            )
            saveReport()
            return
        end
        runtime.redirectFlagPublished = desiredFlag
        addTimeline(string.format(
            "ROUTE %s tick=%u enemy=%s slot=%s "
                .. "source=%s replacement=%s",
            desiredFlag == 1 and "ARMED" or "DISARMED",
            tick,
            runtime.activeEnemy or "none",
            tostring(runtime.routeSlot or "none"),
            runtime.routeSource or "none",
            runtime.routeReplacement or "none"
        ), desiredFlag == 1)
    end
    if desiredFlag == 1 and enabled then
        SETTINGS._queueAlreadyPlayingSwitch()
    end
end

-- =========================================================================
-- BGM CAPTURE PROCESSING
-- =========================================================================

function SETTINGS._readStableCapture()
    for _ = 1, 3 do
        local before =
            safeReadInt(dataRva + DATA_REQUEST_COUNTER_OFFSET)
        local source = safeReadString(
            dataRva + DATA_SOURCE_BUFFER_OFFSET,
            0x40
        )
        local effective = safeReadString(
            dataRva + DATA_EFFECTIVE_BUFFER_OFFSET,
            0x40
        )
        local bgmId = safeReadInt(dataRva + DATA_BGM_ID_OFFSET)
        local volumeBits =
            safeReadInt(dataRva + DATA_VOLUME_BITS_OFFSET)
        local fadeBits =
            safeReadInt(dataRva + DATA_FADE_BITS_OFFSET)
        local timeValue = safeReadInt(dataRva + DATA_TIME_OFFSET)
        local redirects =
            safeReadInt(dataRva + DATA_REDIRECT_COUNTER_OFFSET)
        local missing = safeReadInt(
            dataRva + DATA_TARGET_MISSING_COUNTER_OFFSET
        )
        local after =
            safeReadInt(dataRva + DATA_REQUEST_COUNTER_OFFSET)
        if before ~= nil
            and after ~= nil
            and before == after
            and source ~= nil
            and effective ~= nil
            and bgmId ~= nil
            and volumeBits ~= nil
            and fadeBits ~= nil
            and timeValue ~= nil
            and redirects ~= nil
            and missing ~= nil
        then
            return {
                counter = after,
                source = cleanFixedString(source),
                effective = cleanFixedString(effective),
                bgmId = signed32(bgmId),
                volumeBits = volumeBits,
                fadeBits = fadeBits,
                volume = floatFromBits(volumeBits),
                fadeVolume = floatFromBits(fadeBits),
                time = signed32(timeValue),
                sequence = after,
                redirects = redirects,
                missing = missing,
            }
        end
    end
    return nil
end

function SETTINGS._processCapture()
    local current =
        safeReadInt(dataRva + DATA_REQUEST_COUNTER_OFFSET)
    if current == nil or current == lastRequestCounter then
        return
    end
    local capture = SETTINGS._readStableCapture()
    if capture == nil then
        return
    end

    local requestDelta = counterDelta(
        capture.counter,
        lastRequestCounter
    )
    local redirectDelta = counterDelta(
        capture.redirects,
        lastRedirectCounter
    )
    local missingDelta = counterDelta(
        capture.missing,
        lastTargetMissingCounter
    )
    lastRequestCounter = capture.counter
    lastRedirectCounter = capture.redirects
    lastTargetMissingCounter = capture.missing
    totalRequests = totalRequests + requestDelta
    totalRedirects = totalRedirects + redirectDelta
    totalTargetMissing = totalTargetMissing + missingDelta
    local runtime = SETTINGS._runtime
    runtime.currentEffectiveBgm = capture.effective
    if capture.bgmId >= 0
        and capture.bgmId <= SETTINGS.MAX_TRACKED_BGM_SLOT
    then
        runtime.slotBgm[capture.bgmId] = {
            source = capture.source,
            effective = capture.effective,
            volumeBits = capture.volumeBits,
            fadeBits = capture.fadeBits,
            time = capture.time,
            tick = tick,
        }
    end

    local eventType = redirectDelta > 0
        and "BGM REDIRECT"
        or "BGM PASS"
    if missingDelta > 0 then
        eventType = "BGM REDIRECT FAILED"
    end
    local message = string.format(
        "%s tick=%u seconds=%.3f sequence=%u id=%d "
            .. "active_enemy=%s source=%s effective=%s "
            .. "volume=%s fade_volume=%s time=%d",
        eventType,
        tick,
        tick / 60,
        capture.sequence,
        capture.bgmId,
        tostring(runtime.activeEnemy or "none"),
        capture.source,
        capture.effective,
        formatFloat(capture.volume),
        formatFloat(capture.fadeVolume),
        capture.time
    )
    if requestDelta > 1 then
        message = message
            .. string.format(" coalesced_requests=%u", requestDelta)
    end
    if missingDelta > 0 then
        message = message
            .. " reason=replacement node was not found in the native BGM list"
    end
    addTimeline(
        message,
        SETTINGS.ECHO_ALL_BGM_TO_F2
            or redirectDelta > 0
            or missingDelta > 0
    )
end

function SETTINGS._processDispatchCounter()
    local current =
        safeReadInt(dataRva + DATA_DISPATCH_COUNTER_OFFSET)
    if current == nil or current == lastDispatchCounter then
        return
    end
    local delta = counterDelta(current, lastDispatchCounter)
    lastDispatchCounter = current
    totalActiveSwitches = totalActiveSwitches + delta
    SETTINGS._runtime.activeSwitchQueued = false
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

function SETTINGS._resetRuntimeState()
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
    local runtime = SETTINGS._runtime
    runtime.modelCodeProfiles = {}
    runtime.fingerprintProfiles = {}
    runtime.contextBindings = {}
    runtime.fallbackExclusions = {}
    runtime.profiles = {}
    runtime.fallbackProfile = nil
    runtime.evidence = {}
    runtime.publishedPresence = {}
    runtime.activeEnemy = nil
    runtime.activeProfile = nil
    runtime.activeMatchSource = nil
    runtime.routeLatched = false
    runtime.routeWorld = nil
    runtime.routeRoom = nil
    runtime.routeSource = nil
    runtime.routeReplacement = nil
    runtime.routeSlot = nil
    runtime.redirectFlagPublished = -1
    runtime.activeSwitchQueued = false
    runtime.activeSwitchAttempted = false
    runtime.slotBgm = {}
    runtime.preservedNodes = {}
    runtime.lastNodeScanTick = {}
    runtime.missingNodeReported = {}
    runtime.fallbackExclusionReported = {}
    runtime.currentEffectiveBgm = nil
    graphQueue = {}
    graphQueueHead = 1
    graphQueued = {}
    graphScanned = {}
    graphNodesQueued = 0
    lastGraphRestartTick = -100000
    globalScanOffset = 0

    lastRequestCounter = 0
    lastRedirectCounter = 0
    lastTargetMissingCounter = 0
    lastDispatchCounter = 0
    totalRequests = 0
    totalRedirects = 0
    totalTargetMissing = 0
    totalActiveSwitches = 0
    timelineRows = {}
    timelineCapped = false
    statusLines = {}
    reportDirty = true
    lastReportSaveTick = 0
end

function SETTINGS._combinedMusicInit()
    SETTINGS._resetRuntimeState()

    addStatus(
        "Route: every named enemy inherits "
            .. SETTINGS.DEFAULT_THEME.replacement_bgm
            .. "; individual source/slot/replacement overrides are supported.",
        false
    )
    addStatus(
        "Safety: graph-only unidentified objects cannot use the lock-on "
            .. "fallback; explicit known non-enemy exclusions block Wakka's "
            .. "18-HP projectile before fallback.",
        false
    )
    addStatus(
        "Late detection: an already-playing source is switched on the next "
            .. "main-game frame; the confirmed encounter then remains latched.",
        false
    )
    addStatus(
        "Lifetime safety: replacement nodes are detached from disposable scene "
            .. "lists and retained for the process lifetime.",
        false
    )

    if not SETTINGS.ENABLE then
        addStatus("DISABLED: SETTINGS.ENABLE is false.", true)
        saveReport()
        return
    end
    if not plausibleRuntimeAddress(moduleBase) then
        addStatus("DISABLED: LuaBackend BASE_ADDR is invalid.", true)
        saveReport()
        return
    end
    local configOK, configReason = SETTINGS._compileProfiles()
    if not configOK then
        addStatus("DISABLED: " .. configReason .. ".", true)
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
        safeReadArray(BGM_FORMAT_RVA, #BGM_FORMAT_SIGNATURE),
        BGM_FORMAT_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified BGM format signature mismatch.",
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
    lastRequestCounter =
        safeReadInt(dataRva + DATA_REQUEST_COUNTER_OFFSET) or 0
    lastRedirectCounter =
        safeReadInt(dataRva + DATA_REDIRECT_COUNTER_OFFSET) or 0
    lastTargetMissingCounter = safeReadInt(
        dataRva + DATA_TARGET_MISSING_COUNTER_OFFSET
    ) or 0
    lastDispatchCounter =
        safeReadInt(dataRva + DATA_DISPATCH_COUNTER_OFFSET) or 0
    enabled = true
    SETTINGS._updatePresenceAndRoute()

    addStatus("READY: " .. hookReason .. ".", true)
    addStatus(
        "READY: " .. tostring(SETTINGS._profileCount)
            .. " named enemy profiles are loaded; the unmapped lock-on "
            .. "fallback is disabled. Wait for REPLACEMENT NODE PRESERVED, "
            .. "then enter combat. Use a full restart instead of F1.",
        true
    )
    saveReport()
end

function SETTINGS._combinedMusicFrame()
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
            "DISABLED: another script replaced the multi-enemy BGM/frame hook.",
            true
        )
        saveReport()
        return
    end

    SETTINGS._ensureReplacementNode(
        SETTINGS._runtime.routeReplacement
            or SETTINGS.DEFAULT_THEME.replacement_bgm
    )
    if not enabled then
        return
    end

    local sora = safeReadLong(SORA_POINTER) or 0
    if sora ~= currentSora then
        currentSora = sora
        globalScanOffset = 0
        SETTINGS._restartGraph()
    end

    SETTINGS._processNarrowTargets()
    SETTINGS._updatePresenceAndRoute()
    if not enabled then
        return
    end
    SETTINGS._processDispatchCounter()
    SETTINGS._processCapture()

    if reportDirty
        and tick - lastReportSaveTick
            >= SETTINGS.REPORT_SAVE_INTERVAL_TICKS
    then
        saveReport()
    end
end


    return {
        init = SETTINGS._combinedMusicInit,
        frame = SETTINGS._combinedMusicFrame,
    }
end


-- =========================================================================
-- GENERALIZED PRIVATE-THEME MODULE
-- =========================================================================
-- Every BATTLE_THEME value is compiled from the single ENEMY_SETTINGS table.
-- Each configured enemy receives a private runtime music identity from
-- music900 through music995. These names exist only in the live file manager;
-- no native .bgm, .dat, or remastered/amusic asset is replaced.

local function buildPrivateThemeModule(ENEMY_CONFIG, SHARED)
local SETTINGS = {
    ENABLE = true,
    COPY_CHUNK_SIZE = 0x10000,
    PRESENCE_HOLD_TICKS = SHARED.PRESENCE_HOLD_TICKS or 180,
    FADE_OUT_MS = SHARED.PRIVATE_THEME_FADE_OUT_MS or 1500,
    DEFAULT_BGM_ID = 1,
    FIRST_PRIVATE_MUSIC_ID = 900,
    REQUIRE_VERIFIED_SORA_TARGET = true,
    MAX_PLAUSIBLE_THEME_HP = 1000000,

    THEMES = {},
    THEME_ORDER = {},
    MODEL_CODE_PROFILES = {},
    FINGERPRINT_PROFILES = {},
    CONTEXT_BINDINGS = {},
    NON_ENEMY_EXCLUSIONS = SHARED.NON_ENEMY_EXCLUSIONS or {},
    CONFIGURED_THEME_COUNT = 0,
    VALID_THEME_COUNT = 0,
    INITIAL_THEME = nil,

    REPORT_FILENAME = "KHFM_EnemyConfig_v4_4_7_Theme_Report.txt",
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

-- KH1FM's timed slot-volume/stop wrapper. A target volume of zero calls the
-- native timed stop route before unlinking the playback object, producing a
-- real fade rather than the immediate cut made by BGM_STOP_FUNCTION_RVA.
SETTINGS._BGM_FADE_FUNCTION_RVA = 0x000DD390
SETTINGS._BGM_FADE_FUNCTION_SIGNATURE = {
    0x48, 0x83, 0xEC, 0x28,
    0x48, 0x83, 0x3D, 0x3C, 0xDC, 0x0C, 0x02, 0x00,
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
-- register_bgm_resource inserts each live BGM node at the head of this list.
-- Cached reactivation safely moves the selected existing node back to the
-- head under the same file-manager lock instead of registering its buffer a
-- second time.
local BGM_RESOURCE_LIST_HEAD_RVA = 0x004D65D8
local BGM_RESOURCE_LIST_TAIL_RVA = 0x004D65E0
SETTINGS._BGM_RESOURCE_LIST_COUNT_RVA = 0x004D65E8
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
local DATA_TARGET_NODE_OFFSET = 0x140
local DATA_MAGIC = "BGMW43\0\0"
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

-- Stage 3 never calls register_bgm_resource. It finds the already-owned node
-- by its saved resource ID and exact owned buffer, moves that node to the head
-- of the selectable list, and invokes the native BGM route on the row's slot.
-- This fixes v4.4's
-- duplicate-registration use-after-free crash on a configured enemy's second
-- encounter.
local CACHE_CODE_HEX =
    "514883ec40833d00000000030f85f9000000c7050000000000000000c60500"
    .. "00000004488b0d000000004885c90f8489000000e800000000448b15000000"
    .. "004c8b1d000000004c8b05000000004531c94d85c074524539501875064d39"
    .. "582074094d89c14d8b4008ebe64d85c9742a498b4008498941084c39050000"
    .. "000075074c890d00000000488b0500000000498940084c890500000000488b"
    .. "0d00000000e800000000eb1e488b0d00000000e800000000c6050000000009"
    .. "eb4fc6050000000005eb46b901000000e800000000b9010000004531c0448b"
    .. "0d00000000f30f100d00000000f30f1015000000004c894424204c89442428"
    .. "e800000000f0ff0500000000c60500000000074883c44059ff2500000000"
local CACHE_CODE_SIZE = 0x116
local CACHE_RELOCATIONS = {
    { field = 0x007, next = 0x00C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x014, next = 0x01C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x01E, next = 0x023,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x026, next = 0x02A,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x034, next = 0x038,
        absolute = FILE_MANAGER_LOCK_RVA },
    { field = 0x03B, next = 0x03F,
        data = DATA_TARGET_RESOURCE_OFFSET },
    { field = 0x042, next = 0x046,
        data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x049, next = 0x04D,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x07A, next = 0x07E,
        absolute = BGM_RESOURCE_LIST_TAIL_RVA },
    { field = 0x083, next = 0x087,
        absolute = BGM_RESOURCE_LIST_TAIL_RVA },
    { field = 0x08A, next = 0x08E,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x095, next = 0x099,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x09C, next = 0x0A0,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x0A1, next = 0x0A5,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x0AA, next = 0x0AE,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x0AF, next = 0x0B3,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x0B5, next = 0x0BA,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0BE, next = 0x0C3,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0CB, next = 0x0CF,
        absolute = BGM_STOP_FUNCTION_RVA },
    { field = 0x0DA, next = 0x0DE,
        data = DATA_DISPATCH_TIME_OFFSET },
    { field = 0x0E2, next = 0x0E6,
        data = DATA_DISPATCH_VOLUME_BITS_OFFSET },
    { field = 0x0EA, next = 0x0EE,
        data = DATA_DISPATCH_FADE_BITS_OFFSET },
    { field = 0x0F9, next = 0x0FD,
        absolute = BGM_FUNCTION_RVA },
    { field = 0x100, next = 0x104,
        data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x106, next = 0x10B,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x112, next = 0x116,
        data = DATA_ORIGINAL_FRAME_POINTER_OFFSET },
}

-- Stage 3D reactivates a node that Stage 4 deliberately detached. It inserts
-- the same game-owned resource object at the selectable-list head under the
-- file-manager lock, then uses the row's verified playback slot. No second
-- registration or buffer ownership transfer occurs.
SETTINGS._DETACHED_CACHE_CODE_HEX =
    "514883ec40833d00000000030f85de000000c7050000000000000000c60500"
    .. "00000004488b0d000000004885c97472e8000000004c8b05000000004d85c0"
    .. "744c448b150000000045395018753f4c8b1d000000004d3958207532488b05"
    .. "00000000498940084c8905000000004885c075074c890500000000ff050000"
    .. "0000488b0d00000000e800000000eb1e488b0d00000000e800000000c60500"
    .. "00000009eb4fc6050000000005eb46b901000000e800000000b90100000045"
    .. "31c0448b0d00000000f30f100d00000000f30f1015000000004c894424204c"
    .. "89442428e800000000f0ff0500000000c60500000000074883c44059ff2500"
    .. "000000"
SETTINGS._DETACHED_CACHE_CODE_SIZE = 0x0FB
SETTINGS._DETACHED_CACHE_RELOCATIONS = {
    { field = 0x007, next = 0x00C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x014, next = 0x01C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x01E, next = 0x023,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x026, next = 0x02A,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x030, next = 0x034,
        absolute = FILE_MANAGER_LOCK_RVA },
    { field = 0x037, next = 0x03B,
        data = DATA_TARGET_NODE_OFFSET },
    { field = 0x043, next = 0x047,
        data = DATA_TARGET_RESOURCE_OFFSET },
    { field = 0x050, next = 0x054,
        data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x05D, next = 0x061,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x068, next = 0x06C,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x074, next = 0x078,
        absolute = BGM_RESOURCE_LIST_TAIL_RVA },
    { field = 0x07A, next = 0x07E,
        absolute = SETTINGS._BGM_RESOURCE_LIST_COUNT_RVA },
    { field = 0x081, next = 0x085,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x086, next = 0x08A,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x08F, next = 0x093,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x094, next = 0x098,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x09A, next = 0x09F,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0A3, next = 0x0A8,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0B0, next = 0x0B4,
        absolute = BGM_STOP_FUNCTION_RVA },
    { field = 0x0BF, next = 0x0C3,
        data = DATA_DISPATCH_TIME_OFFSET },
    { field = 0x0C7, next = 0x0CB,
        data = DATA_DISPATCH_VOLUME_BITS_OFFSET },
    { field = 0x0CF, next = 0x0D3,
        data = DATA_DISPATCH_FADE_BITS_OFFSET },
    { field = 0x0DE, next = 0x0E2,
        absolute = BGM_FUNCTION_RVA },
    { field = 0x0E5, next = 0x0E9,
        data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x0EB, next = 0x0F0,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0F7, next = 0x0FB,
        data = DATA_ORIGINAL_FRAME_POINTER_OFFSET },
}

-- register_bgm_resource receives the resource class in EDX. The first-load
-- template was originally assembled for slot/class 1, just like its stop and
-- play calls. A slot-0 theme must patch all three values together; otherwise
-- registration succeeds but the slot-0 playback lookup cannot select the
-- class-1 resource.
local REGISTER_RESOURCE_CLASS_IMMEDIATE_OFFSETS = { 0x05F }
local REGISTER_BGM_IMMEDIATE_OFFSETS = { 0x092, 0x09C }
local CACHE_BGM_IMMEDIATE_OFFSETS = { 0x0C5, 0x0CF }
SETTINGS._DETACHED_CACHE_BGM_IMMEDIATE_OFFSETS = { 0x0AA, 0x0B4 }
SETTINGS._FADE_DETACH_BGM_IMMEDIATE_OFFSETS = { 0x023 }

-- Stage 4 invokes KH1FM's native timed stop and removes the selected private
-- resource from the file manager's selectable BGM list. The resource object
-- and SCD buffer remain allocated for crash-safe later reinsertion, but native
-- battle startup can no longer select the private theme on its own.
SETTINGS._FADE_DETACH_CODE_HEX =
    "514883ec40833d00000000040f85f1000000c7050000000000000000c60500"
    .. "0000000ab9010000000f57c9448b0500000000e800000000488b0d00000000"
    .. "4885c90f84b5000000e800000000448b15000000004c8b1d000000004c8b05"
    .. "000000004531c94d85c0746c4539501875064d39582074094d89c14d8b4008"
    .. "ebe6498b40084d85c9740649894108eb07488905000000004c390500000000"
    .. "75074c890d0000000049c74008000000004c890500000000ff0d0000000048"
    .. "8b0d00000000e800000000f0ff0500000000c605000000000beb2e48c70500"
    .. "00000000000000488b0d00000000e800000000f0ff0500000000c605000000"
    .. "000eeb07c60500000000054883c44059ff2500000000"
SETTINGS._FADE_DETACH_CODE_SIZE = 0x10E
SETTINGS._FADE_DETACH_RELOCATIONS = {
    { field = 0x007, next = 0x00C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x014, next = 0x01C,
        data = DATA_DISPATCH_COMMAND_OFFSET },
    { field = 0x01E, next = 0x023,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x02E, next = 0x032,
        data = DATA_DISPATCH_TIME_OFFSET },
    { field = 0x033, next = 0x037,
        absolute = SETTINGS._BGM_FADE_FUNCTION_RVA },
    { field = 0x03A, next = 0x03E,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x048, next = 0x04C,
        absolute = FILE_MANAGER_LOCK_RVA },
    { field = 0x04F, next = 0x053,
        data = DATA_TARGET_RESOURCE_OFFSET },
    { field = 0x056, next = 0x05A,
        data = DATA_LOAD_BUFFER_OFFSET },
    { field = 0x05D, next = 0x061,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x090, next = 0x094,
        absolute = BGM_RESOURCE_LIST_HEAD_RVA },
    { field = 0x097, next = 0x09B,
        absolute = BGM_RESOURCE_LIST_TAIL_RVA },
    { field = 0x0A0, next = 0x0A4,
        absolute = BGM_RESOURCE_LIST_TAIL_RVA },
    { field = 0x0AF, next = 0x0B3,
        data = DATA_TARGET_NODE_OFFSET },
    { field = 0x0B5, next = 0x0B9,
        absolute = SETTINGS._BGM_RESOURCE_LIST_COUNT_RVA },
    { field = 0x0BC, next = 0x0C0,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x0C1, next = 0x0C5,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x0C8, next = 0x0CC,
        data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x0CE, next = 0x0D3,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0D8, next = 0x0E0,
        data = DATA_TARGET_NODE_OFFSET },
    { field = 0x0E3, next = 0x0E7,
        absolute = FILE_MANAGER_POINTER_RVA },
    { field = 0x0E8, next = 0x0EC,
        absolute = FILE_MANAGER_UNLOCK_RVA },
    { field = 0x0EF, next = 0x0F3,
        data = DATA_DISPATCH_COUNTER_OFFSET },
    { field = 0x0F5, next = 0x0FA,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x0FE, next = 0x103,
        data = DATA_DISPATCH_STATUS_OFFSET },
    { field = 0x10A, next = 0x10E,
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
local lastWorld = nil
local lastRoom = nil
local evidence = {}
local activeEnemy = nil
local activeTheme = nil
local currentTheme = nil
local playbackActive = false
local pendingTheme = nil
local pendingMode = nil
local activeSwitchQueued = false
local stopRequested = false
SETTINGS._unthemedTargetTick = -100000
SETTINGS._unthemedTargetObject = 0
SETTINGS._lastPreservedTargetObject = 0
SETTINGS._sceneChangedThisTick = false
SETTINGS._forceFadeAfterSceneChange = false

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
SETTINGS._lastTargetNode = 0
local totalActiveSwitches = 0
local totalPrivateStops = 0
local totalCachedBytes = 0
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
    ConsolePrint("[EnemyConfigV4.4.7:MultiTheme] " .. message)
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
        "KH1FM Enemy Config v4.4.7 / Multi Private Theme report",
        "Target: KINGDOM HEARTS FINAL MIX.exe / Steam Global 1.0.0.2",
        "Playback: private SCDs are copied into native aligned buffers, "
            .. "registered under private music900-music995 identities, "
            .. "played on each enemy row's native BGM slot, then faded and detached "
            .. "after the configured enemy leaves the encounter.",
        "Native assets: no .bgm, .dat, or remastered/amusic path is replaced.",
        "Configured theme rows: "
            .. tostring(SETTINGS.CONFIGURED_THEME_COUNT),
        "Valid theme rows: " .. tostring(SETTINGS.VALID_THEME_COUNT),
        "Selection gate: verified live Sora+0x74 target only; "
            .. "graph/model-only evidence is ignored for theme activation.",
        "Unthemed-target behavior: a verified lock-on target with no valid "
            .. "BATTLE_THEME preserves the private theme already playing "
            .. "until the target is lost or the scene changes.",
        "Maximum plausible theme-target HP: "
            .. tostring(SETTINGS.MAX_PLAUSIBLE_THEME_HP),
        "Presence hold ticks: " .. tostring(SETTINGS.PRESENCE_HOLD_TICKS),
        "Fade-out milliseconds: " .. tostring(SETTINGS.FADE_OUT_MS),
        "",
        "THEME CATALOG",
    }

    if #SETTINGS.THEME_ORDER == 0 then
        lines[#lines + 1] = "<no valid private theme configured>"
    else
        for _, theme in ipairs(SETTINGS.THEME_ORDER) do
            lines[#lines + 1] = string.format(
                "%s | file=%s | runtime=%s | slot=%u | size=%u | "
                    .. "priority=%d | loaded=%s | detached=%s | "
                    .. "activations=%u",
                theme.name,
                theme.filename,
                theme.runtimeName,
                theme.bgmId,
                theme.size,
                theme.priority,
                tostring(theme.loaded == true),
                tostring(theme.detached == true),
                theme.activations or 0
            )
        end
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "SUMMARY"
    lines[#lines + 1] = "Active enemy: "
        .. tostring(activeEnemy or "none")
    lines[#lines + 1] = "Current private theme: "
        .. tostring(currentTheme ~= nil and currentTheme.name or "none")
    lines[#lines + 1] = "Playback active: "
        .. tostring(playbackActive)
    lines[#lines + 1] = "Pending theme: "
        .. tostring(pendingTheme ~= nil and pendingTheme.name or "none")
    lines[#lines + 1] = string.format(
        "Last verified unthemed target: object=0x%X tick=%d",
        SETTINGS._unthemedTargetObject or 0,
        SETTINGS._unthemedTargetTick or -100000
    )
    lines[#lines + 1] = string.format(
        "On-demand BGM switches completed: %u",
        totalActiveSwitches
    )
    lines[#lines + 1] = string.format(
        "Private BGM fades/detaches completed: %u",
        totalPrivateStops
    )
    lines[#lines + 1] = string.format(
        "Cached native audio bytes: %u",
        totalCachedBytes
    )
    lines[#lines + 1] = string.format(
        "Last dispatcher status: %u",
        lastDispatchStatus
    )
    lines[#lines + 1] = string.format(
        "Last load size: %u",
        lastLoadSize
    )
    lines[#lines + 1] = string.format(
        "Last load buffer: 0x%X",
        lastLoadBuffer
    )
    lines[#lines + 1] = string.format(
        "Last registered resource: 0x%08X",
        lastTargetResource
    )
    lines[#lines + 1] = string.format(
        "Last detached resource node: 0x%X",
        SETTINGS._lastTargetNode
    )
    lines[#lines + 1] = ""
    lines[#lines + 1] = "STARTUP / STATUS"

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

local function patchFrameRouteImmediate(
    code,
    immediateOffsets,
    opcode,
    bgmId,
    fieldName
)
    if type(bgmId) ~= "number"
        or bgmId < 0
        or bgmId > SHARED.MAX_TRACKED_BGM_SLOT
        or bgmId ~= math.floor(bgmId)
    then
        return nil, "private-theme BGM slot is invalid"
    end
    for _, offset in ipairs(immediateOffsets) do
        if code[offset + 1] ~= opcode
            or bytesU32(code, offset + 2) ~= 1
        then
            return nil,
                "embedded " .. fieldName
                    .. " immediate signature mismatch at 0x"
                    .. string.format("%X", offset)
        end
        putU32(code, offset + 1, bgmId)
    end
    return code
end

local function patchFrameBgmId(code, immediateOffsets, bgmId)
    return patchFrameRouteImmediate(
        code,
        immediateOffsets,
        0xB9,
        bgmId,
        "BGM-slot"
    )
end

local function patchFrameResourceClass(code, immediateOffsets, bgmId)
    return patchFrameRouteImmediate(
        code,
        immediateOffsets,
        0xBA,
        bgmId,
        "BGM-resource-class"
    )
end

local function buildHookData()
    local data = {}
    for index = 1, DATA_SIZE do
        data[index] = 0
    end
    local initial = SETTINGS.INITIAL_THEME
    putString(data, DATA_TARGET_NAME_OFFSET, 0x20,
        initial.runtimeName)
    putU32(data, DATA_LOAD_SIZE_OFFSET, initial.size)
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
        "installed multi-theme allocation stage "
            .. "frame_code=0x%X size=%u capacity=%u data=0x%X",
        frameCodeRva,
        ALLOCATION_CODE_SIZE,
        FRAME_CODE_CAPACITY,
        dataRva
    )
end

function SETTINGS._installAllocationStage()
    local frameCode, reason = buildFrameCode(
        ALLOCATION_CODE_HEX,
        ALLOCATION_CODE_SIZE,
        ALLOCATION_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    local ok
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "allocation stage install failed: " .. reason
    end
    SETTINGS._frameStage = "allocation"
    return true
end

function SETTINGS._installRegisterStage(bgmId)
    local frameCode, reason = buildFrameCode(
        REGISTER_CODE_HEX,
        REGISTER_CODE_SIZE,
        REGISTER_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    frameCode, reason = patchFrameBgmId(
        frameCode,
        REGISTER_BGM_IMMEDIATE_OFFSETS,
        bgmId
    )
    if frameCode == nil then
        return false, reason
    end
    frameCode, reason = patchFrameResourceClass(
        frameCode,
        REGISTER_RESOURCE_CLASS_IMMEDIATE_OFFSETS,
        bgmId
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

function SETTINGS._installCacheStage(bgmId)
    local frameCode, reason = buildFrameCode(
        CACHE_CODE_HEX,
        CACHE_CODE_SIZE,
        CACHE_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    frameCode, reason = patchFrameBgmId(
        frameCode,
        CACHE_BGM_IMMEDIATE_OFFSETS,
        bgmId
    )
    if frameCode == nil then
        return false, reason
    end
    local ok
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "cached-play stage install failed: " .. reason
    end
    SETTINGS._frameStage = "cache"
    return true
end

function SETTINGS._installDetachedCacheStage(bgmId)
    local frameCode, reason = buildFrameCode(
        SETTINGS._DETACHED_CACHE_CODE_HEX,
        SETTINGS._DETACHED_CACHE_CODE_SIZE,
        SETTINGS._DETACHED_CACHE_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    frameCode, reason = patchFrameBgmId(
        frameCode,
        SETTINGS._DETACHED_CACHE_BGM_IMMEDIATE_OFFSETS,
        bgmId
    )
    if frameCode == nil then
        return false, reason
    end
    local ok
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "detached-cache stage install failed: " .. reason
    end
    SETTINGS._frameStage = "detached-cache"
    return true
end

function SETTINGS._installFadeDetachStage(bgmId)
    local frameCode, reason = buildFrameCode(
        SETTINGS._FADE_DETACH_CODE_HEX,
        SETTINGS._FADE_DETACH_CODE_SIZE,
        SETTINGS._FADE_DETACH_RELOCATIONS
    )
    if frameCode == nil then
        return false, reason
    end
    frameCode, reason = patchFrameBgmId(
        frameCode,
        SETTINGS._FADE_DETACH_BGM_IMMEDIATE_OFFSETS,
        bgmId
    )
    if frameCode == nil then
        return false, reason
    end
    local ok
    ok, reason = writeArrayChecked(frameCodeRva, frameCode)
    if not ok then
        return false, "fade/detach stage install failed: " .. reason
    end
    SETTINGS._frameStage = "fade-detach"
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
-- MULTI-ENEMY PRIVATE-THEME IDENTIFICATION
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

local function markThemePresent(
    theme,
    source,
    object,
    hp,
    maxHp,
    modelCode
)
    local previous = evidence[theme.name]
    evidence[theme.name] = {
        tick = tick,
        firstTick = previous ~= nil
            and tick - previous.tick <= SETTINGS.PRESENCE_HOLD_TICKS
            and previous.firstTick or tick,
        profile = theme,
        source = source,
        object = object,
        hp = hp,
        maxHp = maxHp,
        modelCode = modelCode,
    }
    if previous == nil
        or tick - previous.tick > SETTINGS.PRESENCE_HOLD_TICKS
    then
        addTimeline(string.format(
            "ENEMY PRESENT tick=%u seconds=%.3f enemy=%s source=%s "
                .. "model=%s object=0x%X HP=%u/%u theme=%s runtime=%s",
            tick,
            tick / 60,
            theme.name,
            source,
            modelCode or "none",
            object,
            hp,
            maxHp,
            theme.filename,
            theme.runtimeName
        ), true)
    end
end

function SETTINGS._markUnthemedTarget(object, hp, maxHp, modelCode)
    local isNewTarget =
        SETTINGS._unthemedTargetObject ~= object
        or tick - SETTINGS._unthemedTargetTick
            > SETTINGS.PRESENCE_HOLD_TICKS
    SETTINGS._unthemedTargetTick = tick
    SETTINGS._unthemedTargetObject = object
    if isNewTarget then
        addTimeline(string.format(
            "UNTHEMED TARGET PRESENT tick=%u seconds=%.3f "
                .. "object=0x%X HP=%u/%u model=%s "
                .. "action=preserve-current-private-theme",
            tick,
            tick / 60,
            object,
            hp,
            maxHp,
            modelCode or "none"
        ), true)
    end
end

local function exclusionMatches(maxHp, fingerprint)
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    for _, exclusion in ipairs(SETTINGS.NON_ENEMY_EXCLUSIONS) do
        local hpMatches = false
        for _, value in ipairs(exclusion.max_hp_values or {}) do
            if value == maxHp then
                hpMatches = true
                break
            end
        end
        if hpMatches
            and world == exclusion.world
            and (exclusion.room == nil or room == exclusion.room)
            and fingerprint ~= nil
            and fingerprint == exclusion.fingerprint
        then
            return exclusion.label
        end
    end
    return nil
end

local function contextTheme(maxHp, fingerprint)
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    for _, binding in ipairs(SETTINGS.CONTEXT_BINDINGS) do
        if world == binding.world
            and (binding.room == nil or room == binding.room)
            and binding.maxValues[maxHp]
            and (
                binding.fingerprint == nil
                or binding.fingerprint == fingerprint
            )
        then
            return binding.profile,
                string.format(
                    "target_context:%02X:%02X:%u",
                    world or 0,
                    room or 0,
                    maxHp
                )
        end
    end
    return nil, nil
end

local function examineEntity(object, source)
    if SETTINGS.REQUIRE_VERIFIED_SORA_TARGET
        and (
            type(source) ~= "string"
            or string.find(source, "Sora+0x74", 1, true) == nil
        )
    then
        return
    end
    if not plausibleRuntimeAddress(object) or object == currentSora then
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
        or maxHp > SETTINGS.MAX_PLAUSIBLE_THEME_HP
    then
        return
    end

    local identity = readMobjIdentity(object)
    local fingerprint = identity ~= nil and identity.fingerprint or nil
    local exclusion = exclusionMatches(maxHp, fingerprint)
    if exclusion ~= nil then
        return
    end

    local modelCode = findModelCode(object, identity)
    local theme = modelCode ~= nil
        and SETTINGS.MODEL_CODE_PROFILES[string.lower(modelCode)]
        or nil
    local matchSource = theme ~= nil
        and "model_code:" .. modelCode .. " via " .. source
        or nil

    if theme == nil and fingerprint ~= nil then
        theme = SETTINGS.FINGERPRINT_PROFILES[fingerprint]
        if type(theme) == "table" then
            matchSource = "fingerprint:" .. fingerprint
                .. " via " .. source
        else
            theme = nil
        end
    end
    if theme == nil then
        theme, matchSource = contextTheme(maxHp, fingerprint)
        if theme ~= nil then
            matchSource = matchSource .. " via " .. source
        end
    end

    if theme ~= nil and theme.available then
        SETTINGS._unthemedTargetTick = -100000
        SETTINGS._unthemedTargetObject = 0
        SETTINGS._lastPreservedTargetObject = 0
        markThemePresent(
            theme,
            matchSource or source,
            object,
            hp,
            maxHp,
            modelCode
        )
    elseif theme == nil then
        SETTINGS._markUnthemedTarget(
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

local function fixedStringBytes(capacity, value)
    local bytes = {}
    for index = 1, capacity do
        bytes[index] = 0
    end
    local length = math.min(string.len(value), capacity - 1)
    for index = 1, length do
        bytes[index] = string.byte(value, index)
    end
    return bytes
end

function SETTINGS._publishThemeFields(theme, buffer, resource, node)
    local writes = {
        {
            kind = "array",
            offset = DATA_TARGET_NAME_OFFSET,
            value = fixedStringBytes(0x20, theme.runtimeName),
            name = "private runtime name",
        },
        {
            kind = "int",
            offset = DATA_LOAD_SIZE_OFFSET,
            value = theme.size,
            name = "SCD size",
        },
        {
            kind = "long",
            offset = DATA_LOAD_BUFFER_OFFSET,
            value = buffer or 0,
            name = "native buffer",
        },
        {
            kind = "int",
            offset = DATA_COPY_PROGRESS_OFFSET,
            value = 0,
            name = "copy progress",
        },
        {
            kind = "int",
            offset = DATA_TARGET_RESOURCE_OFFSET,
            value = resource or 0,
            name = "target resource",
        },
        {
            kind = "long",
            offset = DATA_TARGET_NODE_OFFSET,
            value = node or 0,
            name = "detached resource node",
        },
        {
            kind = "int",
            offset = DATA_DISPATCH_VOLUME_BITS_OFFSET,
            value = primaryVolumeBits,
            name = "volume",
        },
        {
            kind = "int",
            offset = DATA_DISPATCH_FADE_BITS_OFFSET,
            value = primaryFadeBits,
            name = "fade volume",
        },
        {
            kind = "int",
            offset = DATA_DISPATCH_TIME_OFFSET,
            value = primaryTime,
            name = "time",
        },
        {
            kind = "int",
            offset = DATA_DISPATCH_STATUS_OFFSET,
            value = 0,
            name = "status",
        },
    }
    for _, field in ipairs(writes) do
        local ok
        local reason
        if field.kind == "array" then
            ok, reason = writeArrayChecked(
                dataRva + field.offset,
                field.value
            )
        elseif field.kind == "long" then
            ok, reason = writeLongChecked(
                dataRva + field.offset,
                field.value
            )
        else
            ok, reason = writeIntChecked(
                dataRva + field.offset,
                field.value
            )
        end
        if not ok then
            return false, field.name .. " publish failed: "
                .. tostring(reason)
        end
    end
    return true
end

function SETTINGS._queueThemeSwitch(theme)
    if pendingTheme ~= nil or activeSwitchQueued then
        return
    end
    if theme == nil or not theme.available then
        return
    end

    local useCache = theme.loaded
        and plausibleRuntimeAddress(theme.buffer)
        and type(theme.resource) == "number"
        and theme.resource ~= 0
    local useDetachedCache = useCache and theme.detached == true
    local ok
    local reason
    if useCache then
        if useDetachedCache then
            ok, reason = SETTINGS._installDetachedCacheStage(theme.bgmId)
        else
            ok, reason = SETTINGS._installCacheStage(theme.bgmId)
        end
    else
        theme.loaded = false
        theme.buffer = nil
        theme.resource = nil
        theme.node = nil
        theme.detached = false
        ok, reason = SETTINGS._installAllocationStage()
    end
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: dispatcher stage install failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    ok, reason = SETTINGS._publishThemeFields(
        theme,
        useCache and theme.buffer or 0,
        useCache and theme.resource or 0,
        useDetachedCache and theme.node or 0
    )
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: theme publish failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    pendingTheme = theme
    pendingMode = useCache
        and (useDetachedCache and "detached-cache" or "cache")
        or "load"
    activeSwitchQueued = true
    SETTINGS._copyOffset = 0
    SETTINGS._copyFile = nil

    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_COMMAND_OFFSET,
        useCache and 3 or 1
    )
    if not ok then
        pendingTheme = nil
        pendingMode = nil
        activeSwitchQueued = false
        enabled = false
        addStatus(
            "DISABLED: dispatch request failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    addTimeline(string.format(
        "%s QUEUED tick=%u seconds=%.3f enemy=%s slot=%u "
            .. "file=%s runtime=%s size=%u",
        useCache and "CACHED PRIVATE THEME" or "NATIVE BUFFER ALLOCATION",
        tick,
        tick / 60,
        theme.name,
        theme.bgmId,
        theme.filename,
        theme.runtimeName,
        theme.size
    ), true)
end

function SETTINGS._queueThemeFade(theme, reasonText)
    if pendingTheme ~= nil or activeSwitchQueued then
        return
    end
    if theme == nil then
        stopRequested = false
        currentTheme = nil
        playbackActive = false
        return
    end

    local ok
    local reason
    ok, reason = SETTINGS._installFadeDetachStage(theme.bgmId)
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: fade/detach stage install failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    ok, reason = SETTINGS._publishThemeFields(
        theme,
        theme.buffer or 0,
        theme.resource or 0,
        0
    )
    if ok then
        ok, reason = writeIntChecked(
            dataRva + DATA_DISPATCH_TIME_OFFSET,
            SETTINGS.FADE_OUT_MS
        )
    end
    if not ok then
        enabled = false
        addStatus(
            "DISABLED: fade/detach publish failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    pendingTheme = theme
    pendingMode = "fade-detach"
    activeSwitchQueued = true
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_STATUS_OFFSET,
        0
    )
    if ok then
        ok, reason = writeIntChecked(
            dataRva + DATA_DISPATCH_COMMAND_OFFSET,
            4
        )
    end
    if not ok then
        pendingTheme = nil
        pendingMode = nil
        activeSwitchQueued = false
        enabled = false
        addStatus(
            "DISABLED: fade/detach request failed for "
                .. theme.name .. ": " .. tostring(reason) .. ".",
            true
        )
        saveReport()
        return
    end

    addTimeline(string.format(
        "PRIVATE THEME FADE QUEUED tick=%u seconds=%.3f "
            .. "enemy=%s slot=%u fade_ms=%u reason=%s",
        tick,
        tick / 60,
        theme.name,
        theme.bgmId,
        SETTINGS.FADE_OUT_MS,
        tostring(reasonText or "enemy no longer present")
    ), true)
end

function SETTINGS._selectActiveThemeEvidence()
    local best = nil
    for _, item in pairs(evidence) do
        if tick - item.tick <= SETTINGS.PRESENCE_HOLD_TICKS
            and item.profile.available
            and (
                best == nil
                or item.profile.priority > best.profile.priority
                or (
                    item.profile.priority == best.profile.priority
                    and item.profile.name < best.profile.name
                )
            )
        then
            best = item
        end
    end
    return best
end

function SETTINGS._updatePresenceAndRoute()
    local selected = SETTINGS._selectActiveThemeEvidence()
    if selected == nil then
        local preserveForUnthemedTarget =
            not SETTINGS._sceneChangedThisTick
            and not SETTINGS._forceFadeAfterSceneChange
            and tick - SETTINGS._unthemedTargetTick
                <= SETTINGS.PRESENCE_HOLD_TICKS
            and (
                playbackActive
                or currentTheme ~= nil
                or pendingTheme ~= nil
            )
        if preserveForUnthemedTarget then
            if pendingMode ~= "fade-detach" then
                stopRequested = false
            end
            if SETTINGS._lastPreservedTargetObject
                ~= SETTINGS._unthemedTargetObject
            then
                SETTINGS._lastPreservedTargetObject =
                    SETTINGS._unthemedTargetObject
                addTimeline(string.format(
                    "PRIVATE THEME PRESERVED tick=%u seconds=%.3f "
                        .. "theme=%s target=0x%X "
                        .. "reason=verified lock-on target has no theme",
                    tick,
                    tick / 60,
                    currentTheme ~= nil
                        and currentTheme.name
                        or (
                            pendingTheme ~= nil
                                and pendingTheme.name
                                or activeEnemy
                                or "none"
                        ),
                    SETTINGS._unthemedTargetObject
                ), true)
            end
            return
        end
        SETTINGS._lastPreservedTargetObject = 0
        if activeEnemy ~= nil then
            addTimeline(string.format(
                "ROUTE DISARMED tick=%u seconds=%.3f enemy=%s "
                    .. "reason=presence timeout or scene change",
                tick,
                tick / 60,
                activeEnemy
            ), true)
        end
        if pendingMode ~= "fade-detach"
            and (
                playbackActive
                or currentTheme ~= nil
                or pendingTheme ~= nil
            )
        then
            stopRequested = true
        end
        activeEnemy = nil
        activeTheme = nil
        if stopRequested and pendingTheme == nil then
            if currentTheme ~= nil then
                SETTINGS._queueThemeFade(
                    currentTheme,
                    "presence timeout or scene change"
                )
            else
                stopRequested = false
                playbackActive = false
            end
        end
        return
    end

    SETTINGS._lastPreservedTargetObject = 0
    SETTINGS._forceFadeAfterSceneChange = false
    if pendingMode ~= "fade-detach" then
        stopRequested = false
    end
    if activeEnemy ~= selected.profile.name then
        activeEnemy = selected.profile.name
        activeTheme = selected.profile
        playbackActive = false
        addTimeline(string.format(
            "ROUTE ARMED tick=%u seconds=%.3f enemy=%s "
                .. "file=%s runtime=%s priority=%d match=%s",
            tick,
            tick / 60,
            activeEnemy,
            activeTheme.filename,
            activeTheme.runtimeName,
            activeTheme.priority,
            selected.source
        ), true)
    end

    if currentTheme ~= nil
        and currentTheme.name ~= activeTheme.name
    then
        stopRequested = true
        if pendingTheme == nil then
            SETTINGS._queueThemeFade(
                currentTheme,
                "configured encounter theme changed"
            )
        end
        return
    end

    if enabled
        and pendingTheme == nil
        and (
            not playbackActive
            or currentTheme == nil
            or currentTheme.name ~= activeTheme.name
        )
    then
        SETTINGS._queueThemeSwitch(activeTheme)
    end
end

-- =========================================================================
-- PRIVATE SCD COPY AND ON-DEMAND BGM DISPATCH RESULT
-- =========================================================================

function SETTINGS._failPrivateTheme(reason)
    if SETTINGS._copyFile ~= nil then
        pcall(function()
            SETTINGS._copyFile:close()
        end)
        SETTINGS._copyFile = nil
    end
    writeIntChecked(dataRva + DATA_DISPATCH_COMMAND_OFFSET, 0)
    writeIntChecked(dataRva + DATA_DISPATCH_STATUS_OFFSET, 8)
    local failed = pendingTheme
    if failed ~= nil then
        failed.available = false
        failed.failure = tostring(reason)
    end
    pendingTheme = nil
    pendingMode = nil
    activeSwitchQueued = false
    stopRequested = false
    playbackActive = false
    addTimeline(string.format(
        "PRIVATE THEME FAILED tick=%u seconds=%.3f enemy=%s "
            .. "offset=%u reason=%s",
        tick,
        tick / 60,
        failed ~= nil and failed.name or "none",
        SETTINGS._copyOffset or 0,
        tostring(reason)
    ), true)
    saveReport()
end

function SETTINGS._processPrivateScdTransfer()
    if SETTINGS._frameStage ~= "allocation"
        or pendingTheme == nil
        or pendingMode ~= "load"
    then
        return
    end
    local status =
        safeReadByte(dataRva + DATA_DISPATCH_STATUS_OFFSET) or 0
    if status ~= 2 then
        return
    end

    local theme = pendingTheme
    local buffer = safeReadLong(dataRva + DATA_LOAD_BUFFER_OFFSET) or 0
    if not plausibleRuntimeAddress(buffer) then
        SETTINGS._failPrivateTheme(
            "allocator reported an invalid native buffer"
        )
        return
    end

    if SETTINGS._copyFile == nil then
        SETTINGS._copyFile = io.open(theme.path, "rb")
        SETTINGS._copyOffset = 0
        if SETTINGS._copyFile == nil then
            SETTINGS._failPrivateTheme(
                "private SCD could not be reopened"
            )
            return
        end
        addTimeline(string.format(
            "NATIVE BUFFER READY tick=%u seconds=%.3f "
                .. "enemy=%s size=%u buffer=0x%X",
            tick,
            tick / 60,
            theme.name,
            theme.size,
            buffer
        ), true)
    end

    local remaining = theme.size - SETTINGS._copyOffset
    if remaining <= 0 then
        SETTINGS._failPrivateTheme(
            "copy offset exceeded the private SCD size"
        )
        return
    end
    local wanted = math.min(SETTINGS.COPY_CHUNK_SIZE, remaining)
    local chunk = SETTINGS._copyFile:read(wanted)
    if chunk == nil or string.len(chunk) ~= wanted then
        SETTINGS._failPrivateTheme("private SCD read was incomplete")
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
        SETTINGS._failPrivateTheme(reason)
        return
    end

    SETTINGS._copyOffset = SETTINGS._copyOffset + wanted
    ok, reason = writeIntChecked(
        dataRva + DATA_COPY_PROGRESS_OFFSET,
        SETTINGS._copyOffset
    )
    if not ok then
        SETTINGS._failPrivateTheme(reason)
        return
    end
    reportDirty = true
    if SETTINGS._copyOffset < theme.size then
        return
    end

    local extra = SETTINGS._copyFile:read(1)
    SETTINGS._copyFile:close()
    SETTINGS._copyFile = nil
    if extra ~= nil then
        SETTINGS._failPrivateTheme(
            "private SCD changed size during the copy"
        )
        return
    end
    local nativeMagic = safeReadArray(buffer, 8, true)
    local expectedMagic = {
        0x53, 0x45, 0x44, 0x42, 0x53, 0x53, 0x43, 0x46,
    }
    if not arraysEqual(nativeMagic, expectedMagic) then
        SETTINGS._failPrivateTheme(
            "native buffer header did not verify"
        )
        return
    end

    ok, reason = SETTINGS._installRegisterStage(theme.bgmId)
    if not ok then
        SETTINGS._failPrivateTheme(reason)
        return
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_STATUS_OFFSET,
        0
    )
    if not ok then
        SETTINGS._failPrivateTheme(reason)
        return
    end
    ok, reason = writeIntChecked(
        dataRva + DATA_DISPATCH_COMMAND_OFFSET,
        2
    )
    if not ok then
        SETTINGS._failPrivateTheme(reason)
        return
    end
    addTimeline(string.format(
        "PRIVATE SCD COPY VERIFIED tick=%u seconds=%.3f "
            .. "enemy=%s bytes=%u; REGISTRATION QUEUED "
            .. "runtime=%s resource_class=%u slot=%u",
        tick,
        tick / 60,
        theme.name,
        SETTINGS._copyOffset,
        theme.runtimeName,
        theme.bgmId,
        theme.bgmId
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
    SETTINGS._lastTargetNode =
        safeReadLong(dataRva + DATA_TARGET_NODE_OFFSET) or 0
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
        elseif status == 9 then
            local stale = pendingTheme
            if stale ~= nil then
                stale.loaded = false
                stale.buffer = nil
                stale.resource = nil
                stale.node = nil
                stale.detached = false
                totalCachedBytes = math.max(
                    0,
                    totalCachedBytes - stale.size
                )
            end
            pendingTheme = nil
            pendingMode = nil
            activeSwitchQueued = false
            playbackActive = false
            addTimeline(string.format(
                "CACHED RESOURCE MISSING tick=%u seconds=%.3f "
                    .. "enemy=%s; SAFE FRESH LOAD WILL BE QUEUED",
                tick,
                tick / 60,
                stale ~= nil and stale.name or "none"
            ), true)
        elseif status == 14 then
            addTimeline(string.format(
                "PRIVATE RESOURCE ALREADY ABSENT tick=%u seconds=%.3f "
                    .. "enemy=%s; CACHE WILL BE REBUILT ON NEXT USE",
                tick,
                tick / 60,
                pendingTheme ~= nil and pendingTheme.name or "none"
            ), true)
        elseif status == 3 or status == 5
            or status == 6 or status == 8
        then
            local reasons = {
                [3] = "native aligned-buffer allocation failed",
                [5] = "file-manager singleton unavailable",
                [6] = "live BGM resource registration failed",
                [8] = "Lua disk read or native-buffer copy failed",
            }
            local failed = pendingTheme
            pendingTheme = nil
            pendingMode = nil
            activeSwitchQueued = false
            playbackActive = false
            enabled = false
            addTimeline(string.format(
                "ACTIVE SWITCH FAILED tick=%u seconds=%.3f "
                    .. "enemy=%s status=%u reason=%s "
                    .. "load_size=%u buffer=0x%X",
                tick,
                tick / 60,
                failed ~= nil and failed.name or "none",
                status,
                reasons[status],
                lastLoadSize,
                lastLoadBuffer
            ), true)
        elseif status == 7 then
            addTimeline(string.format(
                "PRIVATE BGM RESOURCE READY tick=%u seconds=%.3f "
                    .. "enemy=%s runtime=%s resource_class=%u slot=%u size=%u "
                    .. "buffer=0x%X resource=0x%08X",
                tick,
                tick / 60,
                pendingTheme ~= nil and pendingTheme.name or "none",
                pendingTheme ~= nil
                    and pendingTheme.runtimeName or "none",
                pendingTheme ~= nil
                    and pendingTheme.bgmId or SETTINGS.DEFAULT_BGM_ID,
                pendingTheme ~= nil
                    and pendingTheme.bgmId or SETTINGS.DEFAULT_BGM_ID,
                lastLoadSize,
                lastLoadBuffer,
                lastTargetResource
            ), true)
        elseif status == 10 then
            addTimeline(string.format(
                "PRIVATE BGM FADE ENTERED tick=%u seconds=%.3f "
                    .. "enemy=%s slot=%u fade_ms=%u",
                tick,
                tick / 60,
                pendingTheme ~= nil and pendingTheme.name or "none",
                pendingTheme ~= nil
                    and pendingTheme.bgmId or SETTINGS.DEFAULT_BGM_ID,
                SETTINGS.FADE_OUT_MS
            ), false)
        end
    end

    local current =
        safeReadInt(dataRva + DATA_DISPATCH_COUNTER_OFFSET)
    if current == nil or current == lastDispatchCounter then
        return
    end
    local delta = counterDelta(current, lastDispatchCounter)
    lastDispatchCounter = current

    local completed = pendingTheme
    local completedMode = pendingMode
    if completedMode == "fade-detach" then
        totalPrivateStops = totalPrivateStops + delta
        local cacheRetained = status == 11
            and plausibleRuntimeAddress(SETTINGS._lastTargetNode)
        if completed ~= nil then
            if cacheRetained then
                completed.node = SETTINGS._lastTargetNode
                completed.detached = true
            else
                if completed.loaded then
                    totalCachedBytes = math.max(
                        0,
                        totalCachedBytes - completed.size
                    )
                end
                completed.loaded = false
                completed.buffer = nil
                completed.resource = nil
                completed.node = nil
                completed.detached = false
            end
        end
        currentTheme = nil
        playbackActive = false
        stopRequested = false
        SETTINGS._forceFadeAfterSceneChange = false
        pendingTheme = nil
        pendingMode = nil
        activeSwitchQueued = false
        addTimeline(string.format(
            "PRIVATE THEME FADED AND DETACHED tick=%u seconds=%.3f "
                .. "enemy=%s slot=%u fade_ms=%u count=%u total=%u "
                .. "cache_retained=%s node=0x%X",
            tick,
            tick / 60,
            completed ~= nil and completed.name or "none",
            completed ~= nil
                and completed.bgmId or SETTINGS.DEFAULT_BGM_ID,
            SETTINGS.FADE_OUT_MS,
            delta,
            totalPrivateStops,
            tostring(cacheRetained),
            cacheRetained and SETTINGS._lastTargetNode or 0
        ), true)
        return
    end

    totalActiveSwitches = totalActiveSwitches + delta
    if completed ~= nil then
        if completedMode == "load" and not completed.loaded then
            completed.loaded = true
            completed.buffer = lastLoadBuffer
            completed.resource = lastTargetResource
            completed.node = nil
            completed.detached = false
            totalCachedBytes = totalCachedBytes + completed.size
        end
        completed.detached = false
        completed.activations = (completed.activations or 0) + delta
        currentTheme = completed
        playbackActive = activeEnemy == completed.name
    end
    pendingTheme = nil
    pendingMode = nil
    activeSwitchQueued = false
    addTimeline(string.format(
        "ACTIVE SWITCH EXECUTED tick=%u seconds=%.3f "
            .. "enemy=%s mode=%s count=%u total=%u",
        tick,
        tick / 60,
        completed ~= nil and completed.name or "none",
        tostring(completedMode or "none"),
        delta,
        totalActiveSwitches
    ), true)
end

-- =========================================================================
-- PUBLIC CALLBACKS
-- =========================================================================

function SETTINGS._prepareThemeCatalog()
    if SCRIPT_PATH == nil or io == nil or io.open == nil then
        return false, "Lua script path or file access is unavailable"
    end

    SETTINGS.THEMES = {}
    SETTINGS.THEME_ORDER = {}
    SETTINGS.MODEL_CODE_PROFILES = {}
    SETTINGS.FINGERPRINT_PROFILES = {}
    SETTINGS.CONTEXT_BINDINGS = {}
    SETTINGS.CONFIGURED_THEME_COUNT = 0
    SETTINGS.VALID_THEME_COUNT = 0
    SETTINGS.INITIAL_THEME = nil

    local names = {}
    for name in pairs(SHARED.ENEMIES) do
        names[#names + 1] = name
    end
    table.sort(names)
    local separator = string.find(SCRIPT_PATH, "\\", 1, true)
        and "\\" or "/"

    for index, name in ipairs(names) do
        local filename = ENEMY_CONFIG[name].BATTLE_THEME
        if filename ~= nil then
            SETTINGS.CONFIGURED_THEME_COUNT =
                SETTINGS.CONFIGURED_THEME_COUNT + 1
            local validFilename =
                type(filename) == "string"
                and string.find(filename, "\\", 1, true) == nil
                and string.find(filename, "/", 1, true) == nil
                and string.match(
                    filename,
                    "^[%w][%w _%.%-]*%.win32%.scd$"
                ) ~= nil
            if not validFilename then
                addStatus(
                    "THEME DISABLED: " .. name
                        .. " has an unsafe filename.",
                    true
                )
            else
                local fullPath = SCRIPT_PATH .. separator .. filename
                local file = io.open(fullPath, "rb")
                if file == nil then
                    addStatus(
                        "THEME DISABLED: " .. name
                            .. " SCD was not found: " .. fullPath .. ".",
                        true
                    )
                else
                    local magic = file:read(8)
                    local size = file:seek("end")
                    file:close()
                    if magic ~= "SEDBSSCF"
                        or type(size) ~= "number"
                        or size < 0x100
                        or size > 0x7FFFFFFF
                        or size ~= math.floor(size)
                    then
                        addStatus(
                            "THEME DISABLED: " .. name
                                .. " SCD header or size is invalid.",
                            true
                        )
                    else
                        local row = SHARED.ENEMIES[name]
                        local theme = {
                            name = name,
                            filename = filename,
                            path = fullPath,
                            size = size,
                            runtimeName = string.format(
                                "music%03d.win32.scd",
                                SETTINGS.FIRST_PRIVATE_MUSIC_ID
                                    + index - 1
                            ),
                            priority = row.music_priority or 10,
                            bgmId = row.bgm_slot ~= nil
                                and row.bgm_slot or SETTINGS.DEFAULT_BGM_ID,
                            available = true,
                            loaded = false,
                            buffer = nil,
                            resource = nil,
                            node = nil,
                            detached = false,
                            activations = 0,
                        }
                        SETTINGS.THEMES[name] = theme
                        SETTINGS.THEME_ORDER[
                            #SETTINGS.THEME_ORDER + 1
                        ] = theme
                        SETTINGS.VALID_THEME_COUNT =
                            SETTINGS.VALID_THEME_COUNT + 1
                        if SETTINGS.INITIAL_THEME == nil then
                            SETTINGS.INITIAL_THEME = theme
                        end

                        for _, code in ipairs(row.model_codes or {}) do
                            local key = string.lower(code)
                            if SETTINGS.MODEL_CODE_PROFILES[key] ~= nil
                                and SETTINGS.MODEL_CODE_PROFILES[key]
                                    ~= theme
                            then
                                return false,
                                    "duplicate configured model code " .. code
                            end
                            SETTINGS.MODEL_CODE_PROFILES[key] = theme
                        end
                        for _, fingerprint in ipairs(
                            row.fingerprints or {}
                        ) do
                            local existing =
                                SETTINGS.FINGERPRINT_PROFILES[fingerprint]
                            if existing == nil then
                                SETTINGS.FINGERPRINT_PROFILES[fingerprint] =
                                    theme
                            elseif existing ~= theme then
                                SETTINGS.FINGERPRINT_PROFILES[fingerprint] =
                                    false
                            end
                        end
                        for _, binding in ipairs(
                            row.context_bindings or {}
                        ) do
                            local maxValues = {}
                            for _, value in ipairs(
                                binding.max_hp_values
                                    or { binding.native_max_hp }
                            ) do
                                maxValues[value] = true
                            end
                            SETTINGS.CONTEXT_BINDINGS[
                                #SETTINGS.CONTEXT_BINDINGS + 1
                            ] = {
                                profile = theme,
                                world = binding.world,
                                room = binding.room,
                                maxValues = maxValues,
                                fingerprint = binding.fingerprint,
                            }
                        end
                    end
                end
            end
        end
    end

    if SETTINGS.CONFIGURED_THEME_COUNT == 0 then
        return false, "no BATTLE_THEME is configured"
    end
    if SETTINGS.VALID_THEME_COUNT == 0 then
        return false, "no configured private SCD passed validation"
    end
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
    lastWorld = nil
    lastRoom = nil
    evidence = {}
    activeEnemy = nil
    activeTheme = nil
    currentTheme = nil
    playbackActive = false
    pendingTheme = nil
    pendingMode = nil
    activeSwitchQueued = false
    stopRequested = false
    SETTINGS._unthemedTargetTick = -100000
    SETTINGS._unthemedTargetObject = 0
    SETTINGS._lastPreservedTargetObject = 0
    SETTINGS._sceneChangedThisTick = false
    SETTINGS._forceFadeAfterSceneChange = false
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
    SETTINGS._lastTargetNode = 0
    totalActiveSwitches = 0
    totalPrivateStops = 0
    totalCachedBytes = 0
    timelineRows = {}
    timelineCapped = false
    statusLines = {}
    primaryVolumeBits = 0x3F400000
    primaryFadeBits = 0x3F400000
    primaryTime = 0
    reportDirty = true
    lastReportSaveTick = 0
end

function SETTINGS._privateThemeInit()
    SETTINGS._resetPrivateThemeState()
    addStatus(
        "Route: every configured enemy selects its own private SCD on "
            .. "that enemy row's native BGM slot; the slot fades out and its "
            .. "private resource is detached after that enemy leaves.",
        false
    )
    addStatus(
        "Native music safety: private runtime identities use music900-"
            .. "music995 and no native asset path is replaced.",
        false
    )
    addStatus(
        "Selection: highest internal music priority wins; equal priorities "
            .. "use the enemy name as a stable tie-breaker.",
        false
    )
    addStatus(
        "Target gate: themes accept only the verified live Sora+0x74 "
            .. "target. Unique fingerprints identify the same enemy across "
            .. "rooms; model-graph sightings cannot start music.",
        false
    )
    if not SETTINGS.ENABLE then
        addStatus("DISABLED: SETTINGS.ENABLE is false.", true)
        saveReport()
        return
    end
    if type(SETTINGS.FADE_OUT_MS) ~= "number"
        or SETTINGS.FADE_OUT_MS < 1
        or SETTINGS.FADE_OUT_MS > 10000
        or SETTINGS.FADE_OUT_MS ~= math.floor(SETTINGS.FADE_OUT_MS)
    then
        addStatus(
            "DISABLED: PRIVATE_THEME_FADE_OUT_MS must be an integer "
                .. "from 1 through 10000.",
            true
        )
        saveReport()
        return
    end
    if type(SETTINGS.REQUIRE_VERIFIED_SORA_TARGET) ~= "boolean"
        or type(SETTINGS.MAX_PLAUSIBLE_THEME_HP) ~= "number"
        or SETTINGS.MAX_PLAUSIBLE_THEME_HP < 1
        or SETTINGS.MAX_PLAUSIBLE_THEME_HP > MAX_HP_STORAGE_VALUE
    then
        addStatus(
            "DISABLED: private-theme target-gate settings are invalid.",
            true
        )
        saveReport()
        return
    end
    local catalogOK, catalogReason = SETTINGS._prepareThemeCatalog()
    if not catalogOK then
        addStatus("DISABLED: " .. catalogReason .. ".", true)
        saveReport()
        return
    end
    if not plausibleRuntimeAddress(moduleBase) then
        addStatus("DISABLED: LuaBackend BASE_ADDR is invalid.", true)
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
            SETTINGS._BGM_FADE_FUNCTION_RVA,
            #SETTINGS._BGM_FADE_FUNCTION_SIGNATURE
        ),
        SETTINGS._BGM_FADE_FUNCTION_SIGNATURE
    ) then
        addStatus(
            "DISABLED: verified BGM fade-function signature mismatch.",
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
    lastWorld = safeReadByte(WORLD_ADDRESS)
    lastRoom = safeReadByte(ROOM_ADDRESS)
    SETTINGS._sceneChangedThisTick = false
    SETTINGS._updatePresenceAndRoute()

    addStatus("READY: " .. hookReason .. ".", true)
    addStatus(
        "READY: " .. tostring(SETTINGS.VALID_THEME_COUNT)
            .. " private theme row(s) validated; original native music "
            .. "assets remain untouched.",
        true
    )
    addStatus(
        "Fight a configured enemy. F2 should show ENEMY PRESENT, "
            .. "ROUTE ARMED, NATIVE BUFFER READY, "
            .. "PRIVATE SCD COPY VERIFIED, then ACTIVE SWITCH EXECUTED "
            .. "on the row's selected slot. After defeat it should show PRIVATE THEME "
            .. "FADED AND DETACHED. Use a full game restart instead of F1.",
        true
    )
    saveReport()
end

function SETTINGS._privateThemeFrame()
    if not enabled then
        return
    end
    tick = tick + 1
    SETTINGS._sceneChangedThisTick = false

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
            "DISABLED: another script replaced the multi-theme frame dispatch.",
            true
        )
        saveReport()
        return
    end

    local sora = safeReadLong(SORA_POINTER) or 0
    local world = safeReadByte(WORLD_ADDRESS)
    local room = safeReadByte(ROOM_ADDRESS)
    if sora ~= currentSora then
        currentSora = sora
        globalScanOffset = 0
        SETTINGS._restartGraph()
    end
    if world ~= lastWorld or room ~= lastRoom then
        evidence = {}
        SETTINGS._unthemedTargetTick = -100000
        SETTINGS._unthemedTargetObject = 0
        SETTINGS._lastPreservedTargetObject = 0
        SETTINGS._sceneChangedThisTick = true
        SETTINGS._forceFadeAfterSceneChange =
            playbackActive
            or currentTheme ~= nil
            or pendingTheme ~= nil
        lastWorld = world
        lastRoom = room
        SETTINGS._restartGraph()
    end

    SETTINGS._processNarrowTargets()
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


    return {
        init = SETTINGS._privateThemeInit,
        frame = SETTINGS._privateThemeFrame,
    }
end

local statsModule = buildStatsModule(INTERNAL_CONFIG)
local privateThemeModule = buildPrivateThemeModule(
    ENEMY_SETTINGS,
    INTERNAL_CONFIG
)

function _OnInit()
    INTERNAL_CONFIG._excludedTargets = {}
    INTERNAL_CONFIG._excludedStatsLogged = {}

    -- This preserves the verified two-script initialization order: the enemy
    -- stat cave is reserved first, then the multi-theme dispatcher.
    statsModule.init()
    privateThemeModule.init()
end

function _OnFrame()
    statsModule.frame()
    privateThemeModule.frame()
end
