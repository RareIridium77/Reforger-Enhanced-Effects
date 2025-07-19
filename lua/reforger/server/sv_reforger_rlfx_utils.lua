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

function RLFX.Util:IsObstructed(startPos, endPos)
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        mask = MASK_SOLID_BRUSHONLY
    })

    return tr.Hit
end

local bullets = Reforger.Bullets

function RLFX.Util:GetImpactType(bullet, atypedata)
    return bullets.GetField(bullet, "reforgerImpacttype", atypedata, "exp_mid", isstring)
end