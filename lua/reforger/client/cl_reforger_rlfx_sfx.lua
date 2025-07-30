RLFX = RLFX or {}
RLFX.DebugData = RLFX.DebugData or {}

local rlfx_channel_index = 0 -- DO NOT TOUCH
local rlfx_channel_base = CHAN_RLFX -- DO NOT TOUCH
local rlfx_channel_max = 64 -- DO NOT TOUCH
local rlfx_emit_count = 0 -- DO NOT TOUCH
local cur_channel = CHAN_AUTO

local drawDebugHUD = Reforger.CreateConvar(
    "rlfx.debug.hud", "0",
    "Debug hud for RLFX. 0 - disable, 1 - enable",
    0, 1
)

local function CalculatePitchHeightDiff(sourceZ, listenerZ)
    local minPitch = 65
    local maxPitch = 120
    local maxDelta = 4096 -- max height diffrence when pitch changes

    local heightDiff = math.Clamp(sourceZ - listenerZ, -maxDelta, maxDelta)

    local frac = (heightDiff + maxDelta) / (2 * maxDelta) -- [0, 1]
    return Lerp(1- frac, minPitch, maxPitch)
end

local fallbackHierarchy = {
	["far_obstructed"] = { "dist_obstructed", "mid_obstructed", "close_obstructed" },
	["far"] = { "dist", "mid", "close" },
	["dist_obstructed"] = { "mid_obstructed", "close_obstructed" },
	["dist"] = { "mid", "close" },
	["mid_obstructed"] = { "close_obstructed" },
	["mid"] = { "close" },
	["close_obstructed"] = {},
	["close"] = {},
}

local function GetAmmoSound(ammotype, zone)
	if not isstring(ammotype) or not isstring(zone) then
		return RLFX_DEFAULT_SOUND
	end

	local typeTable = RLFX.CachedSounds[ammotype]
	if not istable(typeTable) then
		return RLFX_DEFAULT_SOUND
	end

	-- 1. Try primary zone
	local entry = typeTable[zone]
	if istable(entry) and istable(entry.paths) and #entry.paths > 0 then
		return entry.paths[math.random(#entry.paths)]
	end

	-- 2. Try hierarchical fallback
	local fallbackZones = fallbackHierarchy[zone]
	if fallbackZones then
		for _, fallback in ipairs(fallbackZones) do
			local fb = typeTable[fallback]
			if istable(fb) and istable(fb.paths) and #fb.paths > 0 then
				return fb.paths[math.random(#fb.paths)]
			end
		end
	end

	-- 3. Try anything else (hard fallback)
	for _, fbZone in pairs(typeTable) do
		if istable(fbZone) and istable(fbZone.paths) and #fbZone.paths > 0 then
			return fbZone.paths[math.random(#fbZone.paths)]
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

    local ear        = ply:EyePos()
    local distance   = pos:Distance(ear)

    local dir        = (pos - ear):GetNormalized()
    local offsetPos  = ear + dir * distance * 0.75

    local soundPath  = GetAmmoSound(ammotype, zone)
    local pitch = CalculatePitchHeightDiff(pos.z, ear.z)

    local function emit()
        if not IsValid(ply) then return end
        EmitSound(soundPath, offsetPos, -2, cur_channel, 1.2, 0, SND_NOFLAGS, pitch)
    end

    if Reforger.IsDeveloper() and drawDebugHUD:GetBool() then
        table.insert(RLFX.DebugData, {
            time = CurTime(),
            zone = zone,
            sound = soundPath,
            pitch = pitch,
            distance = distance,
            pos = pos,
            delay = delay,
            delayEndTime = CurTime() + delay,
            expires = CurTime() + math.max(delay + 1.5, 2)
        })
    end

    if delay <= 0 then
        emit()
    else
        timer.Simple(delay, emit)
    end
end

net.Receive("rlfx.emit", function()
    local pos = net.ReadVector()
    local ammotype = net.ReadString()
    local delay = net.ReadFloat()
    local zone = net.ReadString()

    data = {
        [1] = pos,
        [2] = ammotype,
        [3] = delay,
        [4] = zone,
    }

    cur_channel = GetNextRLFXChannel()
    
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

hook.Add("HUDPaint", "RLFX.DebugHUD", function()
    if not Reforger.IsDeveloper() or not drawDebugHUD:GetBool() then return end

    local w, h = ScrW(), ScrH()
    local x, y = 50, 100
    local font = "DefaultBold"

    draw.SimpleText("RLFX DEBUG HUD", font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    y = y + 30

    local now = CurTime()
    local entries = {}

    for i = #RLFX.DebugData, 1, -1 do
        local entry = RLFX.DebugData[i]
        if now > entry.expires then
            table.remove(RLFX.DebugData, i)
        else
            table.insert(entries, entry)
        end
    end

    table.sort(entries, function(a, b)
        return (a.distance or 0) < (b.distance or 0)
    end)

    local zoneColors = {
        close = Color(124, 255, 124),
        mid   = Color(255, 255, 109),
        dist  = Color(255, 181, 108),
        far   = Color(255, 185, 185)
    }

    for _, entry in ipairs(entries) do
        local zone = entry.zone or "???"
        local sound = entry.sound or "unknown"
        local dist = (entry.distance or 0) / 52.493
        local pitch = entry.pitch or "?"
        local pitchValue = tonumber(pitch) or 100
        local pitchFrac = math.Clamp((pitchValue - 65) / (120 - 65), 0, 1)
        local barWidth = 100
        local barHeight = 6

        surface.SetDrawColor(40, 40, 40, 200)
        surface.DrawRect(x, y + 2, barWidth, barHeight)

        surface.SetDrawColor(100, 200, 255, 255)
        surface.DrawRect(x, y + 2, pitchFrac * barWidth, barHeight)

        y = y + barHeight + 4
        
        local delayLeft = math.max(0, (entry.delayEndTime or 0) - CurTime())
        local delayStr = delayLeft > 0 and string.format("delay: %.2fs", delayLeft) or "emitted"

        local color = zoneColors[zone] or Color(180, 180, 180)

        local text = string.format(
            "[%s] %s | %.1fm | pitch: %s | %s",
            zone, sound, dist, pitch, delayStr
        )

        draw.SimpleText(text, font, x, y, color, TEXT_ALIGN_LEFT)
        y = y + 18
    end
end)
