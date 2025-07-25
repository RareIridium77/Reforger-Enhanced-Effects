AddCSLuaFile()
RLFX = RLFX or {}

--- [ Sound ] ---
CHAN_RLFX = CHAN_USER_BASE + 1 -- DO NOT TOUCH
RLFX_DEFAULT_SOUND = "ambient/voices/squeal1.wav"

--- [ Distance Zones ] ---
RLFX.DistanceZones = {
    { name = "close", min = 0,     max = 512 },
    { name = "mid",   min = 512,  max = 2048 },
    { name = "dist",  min = 2048,  max = 12500 },
    { name = "far",   min = 12500, max = math.huge }
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

RLFX.DSP_Openspace = {
    close = 0,
    mid   = 0,
    dist  = 0,
    far   = 8
}

RLFX.DSP_Obstructed = {
    close = 1,
    mid = 0,
    dist = 8,
    far = 16
}

local function RLFX_CheckPlayerFramework(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        if not istable(_G.Reforger) then
            ply:ChatPrint("[Reforger] Required Reforger Framework is missing. Please install it here: https://steamcommunity.com/sharedfiles/filedetails/?id=3516478641")
        end
    end)
end
hook.Add("PlayerInitialSpawn", "Reforger.RLFX_CheckPlayerFramework", RLFX_CheckPlayerFramework)
