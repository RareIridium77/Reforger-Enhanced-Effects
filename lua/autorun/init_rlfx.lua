AddCSLuaFile()
RLFX = RLFX or {}

--- [ Sound ] ---
CHAN_RLFX = CHAN_USER_BASE + 1 -- DO NOT TOUCH
RLFX_DEFAULT_SOUND = "ambient/voices/squeal1.wav"

--- [ Distance Zones ] ---
RLFX.DistanceZones = {
    { name = "far",   min = 12288, max = math.huge },
    { name = "dist",  min = 8096,  max = 12288 },
    { name = "mid",   min = 2048,  max = 8096 },
    { name = "close", min = 0,     max = 2048 },
}

RLFX.FallbackZones = { "close", "mid", "dist", "far" }

--- [ Sound Speed Conditions ] ---

RLFX_SOUND_AIR = 0
RLFX_SOUND_WATER = 1
RLFX_SOUND_CUSTOM = 3

RLFX.SoundSpeed = {
    [RLFX_SOUND_AIR] = 343,
    [RLFX_SOUND_WATER] = 1490,
    [RLFX_SOUND_CUSTOM] = 1147
}

--- [ Sound DSP ] ---

RLFX_DSP_DEFAULT = 0

local function RLFX_CheckPlayerFramework(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        if not istable(_G.Reforger) then
            ply:ChatPrint("[Reforger] Required Reforger Framework is missing. Please install it here: https://steamcommunity.com/sharedfiles/filedetails/?id=3516478641")
        end
    end)
end
hook.Add("PlayerInitialSpawn", "Reforger.RLFX_CheckPlayerFramework", RLFX_CheckPlayerFramework)