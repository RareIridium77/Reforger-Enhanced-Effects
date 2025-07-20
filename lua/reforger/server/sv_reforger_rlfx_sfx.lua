util.AddNetworkString("rlfx.emit")

RLFX = RLFX or {}

local rfxnet = RLFX.Net
local rfxdata = RLFX.Data
local rfxutil = RLFX.Util
local rvfx    = RLFX.vfx

local net_IsValidAMT = rfxnet.IsValidAMT
local soundSpeed = RLFX.SoundSpeed[RLFX_SOUND_AIR]

local maxDistanceCvar = Reforger.CreateConvar("rlfx.distance.max", "20000", "Maximum distance that sound inside can play. More than this distance sound will not play", 8000, 49999)
local minDistanceCvar = Reforger.CreateConvar("rlfx.distance.min", "500", "Minimum distance that sound outer can play. Less than this distance sound will not play", 5, 8000)

function RLFX:EmitSound(pos, ammotype)
    if not isvector(pos) then return end
    if not net_IsValidAMT(ammotype) then return end

    local cached = {}
    local humanPlayers = player.GetHumans()

    for _, ply in ipairs(humanPlayers) do
        local earPos = ply:GetViewEntity():GetPos()
        local dist = pos:Distance(earPos)

        if dist < minDistanceCvar:GetFloat() or dist > maxDistanceCvar:GetFloat() then continue end
        if hook.Run("CanPlayerPlayRLFX", ply, pos, ammotype, dist) == false then continue end

        local key = tostring(earPos)
        local delay, zone, obstructed, dsp = unpack(cached[key] or {})

        if not delay then
            delay = rfxutil:GetSoundDelay(dist, soundSpeed, pos.z)
            zone = RLFX:GetZone(dist)
            obstructed = rfxutil:IsObstructed(pos, earPos)
            dsp = RLFX:GetDSPForZone(zone, obstructed)
            cached[key] = {delay, zone, obstructed, dsp}
        end

        net.Start("rlfx.emit", false)
        net.WriteVector(pos)
        net.WriteString(ammotype)
        net.WriteFloat(delay)
        net.WriteString(zone)
        net.WriteBool(obstructed)
        net.WriteUInt(dsp, 8)
        net.Send(ply)
    end
end

