RLFX = RLFX or {}

local rlfx_channel_index = 0 -- DO NOT TOUCH
local rlfx_channel_base = CHAN_RLFX -- DO NOT TOUCH
local rlfx_channel_max = 64 -- DO NOT TOUCH
local rlfx_emit_count = 0 -- DO NOT TOUCH

local function CalculatePitch(height)
    local minPitch = 90
    local maxPitch = 110
    local baseHeight = 0
    local maxHeight = 10000

    local frac = math.Clamp((height - baseHeight) / (maxHeight - baseHeight), 0, 1)
    return Lerp(1 - frac, maxPitch, minPitch)
end

local function GetAmmoSound(ammotype, zone)
	if not isstring(ammotype) or not isstring(zone) then
		return RLFX_DEFAULT_SOUND
	end

	local typeTable = RLFX.CachedSounds[ammotype]
	if not istable(typeTable) then
		return RLFX_DEFAULT_SOUND
	end

	local entry = typeTable[zone]
	if istable(entry) and istable(entry.paths) and #entry.paths > 0 then
		return entry.paths[math.random(#entry.paths)]
	end

	for _, fallback in ipairs(RLFX.FallbackZones or {}) do
		local fb = typeTable[fallback]
		if istable(fb) and istable(fb.paths) and #fb.paths > 0 then
			return fb.paths[math.random(#fb.paths)]
		end
	end

	return RLFX_DEFAULT_SOUND
end

local function GetNextRLFXChannel()
    local chan = rlfx_channel_base + rlfx_channel_index

    rlfx_emit_count = rlfx_emit_count + 1
    if rlfx_emit_count >= 3 then
        rlfx_emit_count = 0
        rlfx_channel_index = (rlfx_channel_index + 1) % rlfx_channel_max
    end

    return chan
end

local function PlayDistantShotSound(data)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local pos        = data[1]
    local ammotype   = data[2]
    local delay      = data[3]
    local zone       = data[4]
    local obstructed = data[5]
    local dsp        = data[6]

    local ear        = ply:EyePos()
    local distance   = pos:Distance(ear)

    local dir        = (pos - ear):GetNormalized()
    local offsetPos  = ear + dir * distance * 0.1 -- Offset to avoid sound being too close to the player
    
    local soundPath  = GetAmmoSound(ammotype, zone)

    local function emit()
        if not IsValid(ply) then return end

        debugoverlay.Sphere(offsetPos, 10, 0.1, Color(255, 0, 0), true)

        local chan = GetNextRLFXChannel()
        local pitch = CalculatePitch(pos.z)
        EmitSound(soundPath, offsetPos, -1, chan, 0.75, 0, SND_NOFLAGS, pitch, dsp)
    end
    if delay <= 0 then emit() else timer.Simple(delay, emit) end
end

net.Receive("rlfx.emit", function()
    local pos = net.ReadVector()
    local ammotype = net.ReadString()
    local delay = net.ReadFloat()
    local zone = net.ReadString()
    local obstructed = net.ReadBool()
    local dsp = net.ReadUInt(8)

    data = {
        [1] = pos,
        [2] = ammotype,
        [3] = delay,
        [4] = zone,
        [5] = obstructed,
        [6] = dsp
    }
    
    PlayDistantShotSound(data)
end)

hook.Add("gparticle.PostEmit", "RLFX.MuzzleFlash", function(p, j, gp)
    local particleID = gp:GetParticleID()

    if particleID == "rlfx.heat.spark" then
        local dlight = DynamicLight(j + 1)
        if dlight then
            dlight.pos = p:GetPos()
            dlight.r = 255
            dlight.g = 220
            dlight.b = 100
            dlight.brightness = 5
            dlight.decay = 1000
            dlight.size = 128
            dlight.dietime = CurTime() + 1
        end
        return
    end

    if particleID == "rlfx.muzzleflash" then
        local dlight = DynamicLight(j + 1)
        if dlight then
            dlight.pos = p:GetPos()
            dlight.r = 255
            dlight.g = 150
            dlight.b = 70
            dlight.brightness = 4
            dlight.decay = 2000
            dlight.size = p:GetStartSize() * 0.75
            dlight.dietime = CurTime() + 1
        end
    end
end)