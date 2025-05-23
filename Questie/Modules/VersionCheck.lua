local addonName, _ = ...

-- Check addon is not renamed to avoid conflicts in global name space.
if addonName ~= "Questie" then
    local msg = { "You have renamed Questie addon.", "This is restricted to avoid issues.", "Please remove '"..addonName.."'", "and reinstall the original version."}
    StaticPopupDialogs["QUESTIE_ADDON_NAME_ERROR"] = {
        text = "|cffff0000ERROR|r\n"..msg[1].."\n"..msg[2].."\n\n"..msg[3].."\n"..msg[4],
        button2 = "OK",
        hasEditBox = false,
        whileDead = true,
    }

    C_Timer.After(4, function()
        DEFAULT_CHAT_FRAME:AddMessage("---------------------------------")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR|r: |cff42f5ad"..msg[1].."|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR|r: |cff42f5ad"..msg[2].."|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR|r: |cff42f5ad"..msg[3].."|r")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR|r: |cff42f5ad"..msg[4].."|r")
        DEFAULT_CHAT_FRAME:AddMessage("---------------------------------")
        error("ERROR: "..msg[1].." "..msg[2].." "..msg[3])
    end)
    StaticPopup_Show("QUESTIE_ADDON_NAME_ERROR")
    return
end

if Questie then
    C_Timer.After(4, function()
        error("ERROR!! -> Questie already loaded! Please only have one Questie installed!")
        for _=1, 10 do
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000ERROR!!|r -> Questie already loaded! Please only have one Questie installed!")
        end
    end);
    error("ERROR!! -> Questie already loaded! Please only have one Questie installed!")
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000ERROR!!|r -> Questie already loaded! Please only have one Questie installed!")
    Questie = {}
    return
end

--Initialized below
---@class Questie : AceAddon, AceConsole-3.0, AceEvent-3.0, AceTimer-3.0, AceComm-3.0, AceBucket-3.0
Questie = LibStub("AceAddon-3.0"):NewAddon("Questie", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceBucket-3.0")

-- preinit placeholder to stop tukui crashing from literally force-removing one of our features no matter what users select in the config ui
Questie.db = {profile={minimap={hide=false}}}

-- prevent multiple warnings for the same ID, not sure the best place to put this
Questie._sessionWarnings = {}

--- Addon is running on Classic MoP client
---@type boolean
Questie.IsMoP = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC

--- Addon is running on Classic Cata client
---@type boolean
Questie.IsCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC

--- Addon is running on Classic Wotlk client
---@type boolean
Questie.IsWotlk = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

--- Addon is running on Classic TBC client
---@type boolean
Questie.IsTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

--- Addon is running on Classic "Vanilla" client: Means Classic Era and its seasons like SoM
---@type boolean
Questie.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

--- Addon is running on Classic "Vanilla" client and on Era realm (non-seasonal)
---@type boolean
Questie.IsEra = Questie.IsClassic and (not C_Seasons.HasActiveSeason())

-- See https://wowpedia.fandom.com/wiki/API_C_Seasons.GetActiveSeason

--- Addon is running on Classic "Vanilla" client and on Season of Mastery realm specifically
---@type boolean
Questie.IsSoM = Questie.IsClassic and C_Seasons.HasActiveSeason() and (C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfMastery)

--- Addon is running on Classic "Vanilla" client and on Season of Discovery realm specifically
---@type boolean
Questie.IsSoD = Questie.IsClassic and C_Seasons.HasActiveSeason() and (C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery)

--- Addon is running on Classic "Vanilla" client and on Classic Anniversary realm ( )
---@type boolean
Questie.IsAnniversary = Questie.IsClassic and C_Seasons.HasActiveSeason() and (C_Seasons.GetActiveSeason() == 11) -- TODO: Use Enum or new API if there will be one

--- Addon is running on Classic "Vanilla" client and on Classic Anniversary Hardcore realm
---@type boolean
Questie.IsAnniversaryHardcore = Questie.IsClassic and C_Seasons.HasActiveSeason() and (C_Seasons.GetActiveSeason() == 12) -- TODO: Use Enum or new API if there will be one

--- Addon is running on a HardCore realm specifically
---@type boolean
Questie.IsHardcore = C_GameRules and C_GameRules.IsHardcoreActive()
