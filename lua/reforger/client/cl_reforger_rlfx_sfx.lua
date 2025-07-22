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

net.Receive("rlfx.dlight", function()
    local index = net.ReadUInt(16)
    local pos = net.ReadVector()
    local r = net.ReadUInt(8)
    local g = net.ReadUInt(8)
    local b = net.ReadUInt(8)
    local brightness = net.ReadFloat()
    local decay = net.ReadFloat()
    local delay = net.ReadFloat()
    local size = net.ReadFloat()

    if not isvector(pos) then return end

    local dlight = DynamicLight(index)
    if dlight then
        dlight.pos = pos
        dlight.r = r
        dlight.g = g
        dlight.b = b
        dlight.brightness = brightness
        dlight.decay = decay
        dlight.size = size
        dlight.dietime = CurTime() + delay
    end
end)

local allowDlight = Reforger.CreateConvar(
    "rlfx.tracelight.allow", "1",
    "Allow dynamic light for bullets. 0 - disable, 1 - enable",
    0, 1
)

local tracerColorTable = {
    ["lvs_tracer_orange"] = {255, 150, 50},
    ["lvs_tracer_yellow"] = {255, 255, 50},
    ["lvs_tracer_green"] = {50, 255, 50},
    ["lvs_tracer_purple"] = {150, 50, 255},
    ["lvs_tracer_cyan"] = {50, 255, 255},
    ["lvs_tracer_black"] = {0, 0, 0},
    ["lvs_tracer_white"] = {255, 255, 255},
    ["lvs_tracer_gray"] = {150, 150, 150},
    ["lvs_tracer_red"] = {255, 50, 50},
    ["lvs_trace_white"] = {255, 255, 255},
    ["lvs_tracer_blue"] = {50, 50, 255},
}

local function RLFX_traceDynamicLight()
    if allowDlight:GetBool() == false then
        hook.Remove("Think", "RLFX.TraceLightThink")
        return
    end

    for id, bullet in pairs(LVS._ActiveBullets) do
        if not istable(bullet) or not isfunction(bullet.GetBulletIndex) then continue end
        if bullet.bulletRemoved then continue end

        local index = bullet:GetBulletIndex()
        local pos = bullet.curpos or bullet:GetPos()

        local dlight = DynamicLight(index + 1)
        local color = bullet.TracerColor or tracerColorTable[bullet.TracerName] or {255, 180, 70}
        if dlight then
            dlight.pos = pos
            dlight.r = color[1]
            dlight.g = color[2]
            dlight.b = color[3]
            dlight.brightness = 5.9
            dlight.decay = 2000
            dlight.size = 180 + bullet.HullSize
            dlight.dietime = CurTime() + 1
        end
    end
end

cvars.AddChangeCallback(allowDlight:GetName(), function(cvar, oldV, newV)
    if tonumber(newV) == 1 then
        hook.Add("Think", "RLFX.TraceLightThink", RLFX_traceDynamicLight)
    else
        hook.Remove("Think", "RLFX.TraceLightThink")
    end
end)

if allowDlight:GetBool() then
    hook.Add("Think", "RLFX.TraceLightThink", RLFX_traceDynamicLight)
end