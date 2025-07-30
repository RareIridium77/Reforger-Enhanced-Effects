util.AddNetworkString("rlfx.emit")

RLFX = RLFX or {}

RLFX.Util = RLFX.Util or {}

--- Simplified function for sound speed by height
local __altitude = function(alt) return
    --- Loosing 6 m/s per 150 meters (because of source engine). Minimum is 295 m/s (for ~10km)
    math.max(295, 340 - (alt / 150) * 6)
end

function RLFX.Util:GetSoundDelay(d, csp, altitude)
    assert(isnumber(csp) and isnumber(d) and isnumber(csp), "You gived args where one ore more value are not number.")

    altitude = isnumber(altitude) and altitude or 0
    local speed = __altitude(altitude)
    speed = math.min(speed, csp)
    return d * 0.01905 / speed
end

local rfxnet = RLFX.Net
local rfxdata = RLFX.Data
local rfxutil = RLFX.Util
local rvfx    = RLFX.vfx

local net_IsValidAMT = rfxnet.IsValidAMT
local soundSpeed = RLFX.SoundSpeed[RLFX_SOUND_AIR]

local maxDistanceCvar = Reforger.CreateConvar("rlfx.distance.max", "20000", "Maximum distance that sound inside can play. More than this distance sound will not play", 8000, 49999)
local minDistanceCvar = Reforger.CreateConvar("rlfx.distance.min", "500", "Minimum distance that sound outer can play. Less than this distance sound will not play", 5, 8000)

function RLFX:EmitSound(pos, ammotype, zoneOverride)
    if not isvector(pos) then return end
    if not net_IsValidAMT(ammotype) then return end

    local humanPlayers = player.GetHumans()

    for _, ply in ipairs(humanPlayers) do
        if not IsValid(ply) then continue end

        local earPos = ply:EyePos()
        local dist = pos:Distance(earPos)

        if dist < minDistanceCvar:GetFloat() or dist > maxDistanceCvar:GetFloat() then continue end
        if hook.Run("CanPlayerPlayRLFX", ply, pos, ammotype, dist) == false then continue end

        local delay = rfxutil:GetSoundDelay(dist, soundSpeed, pos.z)
        local zone = zoneOverride or RLFX:GetZone(pos, earPos, dist, ammotype)

        net.Start("rlfx.emit", true)
            net.WriteVector(pos)
            net.WriteString(ammotype)
            net.WriteFloat(delay)
            net.WriteString(zone)
        net.Send(ply)
    end
end
