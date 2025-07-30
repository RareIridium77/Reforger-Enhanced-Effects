RLFX = RLFX or {}

function RLFX:IsObstructed(from, to)
    local tr = util.TraceLine({
        start = from,
        endpos = to,
        mask = MASK_SOLID_BRUSHONLY,
    })
    return tr.Hit and not tr.StartSolid
end

function RLFX:GetZone(from, to, distance, ammoType)
    local isObstructed = self:IsObstructed(from, to)
    local sounds = RLFX.CachedSounds[ammoType]

    for i = #self.DistanceZones, 1, -1 do
        local zone = self.DistanceZones[i]
        if distance >= zone.min and distance < zone.max then
            local zoneName = zone.name

            if isObstructed then
                local obstructedName = zoneName .. "_obstructed"
                if sounds and sounds[obstructedName] then
                    return obstructedName
                end
            end

            return zoneName
        end
    end

    if isObstructed then
        if sounds and sounds["far_obstructed"] then
            return "far_obstructed"
        end
    end

    return "far"
end

function RLFX:GetDSPForZone()
    return RLFX_DSP_DEFAULT
end