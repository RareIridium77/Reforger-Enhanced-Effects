RLFX = RLFX or {}

--- [ Networking ] ---
RLFX.Net = RLFX.Net or {}
RLFX.Net.BaseDelay = 0.01 -- base delay for packet sending to client. Helps to sync every delay for players.
RLFX.Net.MaxBytes = 32 -- maximum bytes to send to client

RLFX.Net.IsValidAMT = function(str)
    return isstring(str)
        and #str <= 24 -- maximum for ammotype name is 24 (Sound Caching and Data sending)
        and string.match(str, "^[%w%_%-]+$") ~= nil
end

--- [ Data Handling ] ---
RLFX.Data = RLFX.Data or {}

local Data = RLFX.Data

Data.TracerAmmoType = Data.TracerAmmoType or {}
Data.ValidSplashDamage = Data.ValidSplashDamage or {}
Data.TracerImpactType = Data.TracerImpactType or {}

--- Add tracer ammo type
function Data:AddTracerAmmoType(tracerName, ammoType, force)
    assert(isstring(tracerName), "tracerName must be a string!")
    assert(isstring(ammoType), "ammoType must be a string!")

    if self.TracerAmmoType[tracerName] and not force then
        ErrorNoHalt(tracerName .. " already exists in TracerAmmoType. Use force = true to overwrite.\n")
        return
    end

    self.TracerAmmoType[tracerName] = ammoType
end

--- Add valid splash damage type
function Data:AddValidSplashDamage(dmgType, force)
    assert(isnumber(dmgType), "dmgType must be a number!")

    if self.ValidSplashDamage[dmgType] ~= nil and not force then
        ErrorNoHalt("Damage type " .. dmgType .. " already set in ValidSplashDamage.\n")
        return
    end

    self.ValidSplashDamage[dmgType] = true
end

--- Add impact type
function Data:AddImpactType(d)
    local types = self.TracerImpactType
    local tracerName, ammotype, heat, he, force = d[1], d[2], d[3], d[4], d[5]

    assert(isstring(tracerName), "tracerName field should be a string value!")
    assert(isstring(ammotype), "ammotype field should be a string value!")
    assert(isbool(heat) and isbool(he), "he or heat field should be a boolean value!")

    if types[tracerName] and not force then
        ErrorNoHalt(tracerName .. " already exists in TracerImpactType. Use force = true to overwrite.\n")
        return 
    end

    types[tracerName] = {
        name = ammotype,
        heat = heat,
        he = he
    }
end

-- [ Default Impact Types ]
local defaultImpactTypes = {
    -- { tracerName, impactName, heat, he }
    { "lvs_tracer_autocannon",           "exp_mid",   true,  false },
    { "lvs_haubitze_trail",              "exp_mid",   false, false },
    { "lvs_haubitze_trail_improved",     "exp_mid",   false, false },
    { "lvs_tracer_cannon",               "exp_large", false, false },
    { "lvs_tracer_cannon_improved",      "exp_large", false, false },
}

for _, entry in ipairs(defaultImpactTypes) do
    Data:AddImpactType(entry)
end

-- [ Default Ammo Types ]
local defaultAmmoTypes = {
    -- { tracerName, ammoType }
    { "lvs_tracer_autocannon",       "25mm" },
    { "lvs_haubitze_trail",          "exp_mid" },
    { "lvs_haubitze_trail_improved", "exp_mid" },
    { "lvs_tracer_cannon",           "tank_fire" },
    { "lvs_tracer_cannon_improved",  "tank_fire" },
}

for _, entry in ipairs(defaultAmmoTypes) do
    Data:AddTracerAmmoType(entry[1], entry[2])
end

-- [ Default Splash Damage Types ]
local defaultSplashTypes = {
    DMG_BLAST,
    DMG_AIRBOAT,
    DMG_SONIC,
}

for _, dmgType in ipairs(defaultSplashTypes) do
    Data:AddValidSplashDamage(dmgType)
end

RLFX.Data = Data