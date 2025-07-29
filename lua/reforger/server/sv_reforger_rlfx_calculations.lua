RLFX = RLFX or {}

function RLFX:GetZone(distance)
    for i = 1, #RLFX.DistanceZones do
        local zone = RLFX.DistanceZones[i]
        if distance >= zone.min and distance < zone.max then
            return zone.name
        end
    end
    return "far"
end

function RLFX:GetDSPForZone()
    return RLFX_DSP_DEFAULT
end