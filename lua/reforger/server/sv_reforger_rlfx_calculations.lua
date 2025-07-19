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

function RLFX:GetDSPForZone(zone, obstructed)
    if not zone then return RLFX_DSP_DEFAULT end
    return (obstructed and RLFX.DSP_Obstructed[zone]) or RLFX.DSP_Openspace[zone] or RLFX_DSP_DEFAULT
end