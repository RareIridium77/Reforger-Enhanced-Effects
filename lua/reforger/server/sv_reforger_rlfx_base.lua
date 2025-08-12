RLFX = RLFX or {}

---// SECTION [ Networking ]
RLFX.Net = RLFX.Net or {}
RLFX.Net.BaseDelay = 0.01 --//NOTE base delay for packet sending to client. Helps to sync every delay for players.
RLFX.Net.MaxBytes = 32 --//NOTE maximum bytes to send to client

RLFX.Net.IsValidAMT = function(str)
    return isstring(str)
        and #str <= 24 --//NOTE maximum for ammotype name is 24 (Sound Caching and Data sending)
        and string.match(str, "^[%w%_%-]+$") ~= nil
end

--// !SECTION

---// SECTION [ Data Handling ]
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

--- Get tracer ammo type
function Data:GetTracerAmmoType(tracerName)
    assert(isstring(tracerName), "tracerName must be a string!")

    return self.TracerAmmoType[tracerName]
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

--- Is Valid splash damage?
function Data:IsValidDamage(dmgType)
    assert(isnumber(dmgType), "dmgType must be a number!")

    return self.ValidSplashDamage[dmgType] == true --// NOTE Only if true
end

--- Add impact type
function Data:AddImpactType(d)
    local tracerName, ammotype, heat, he, force = d[1], d[2], d[3], d[4], d[5]

    assert(isstring(tracerName), "tracerName field should be a string value!")
    assert(isstring(ammotype), "ammotype field should be a string value!")
    assert(isbool(heat) and isbool(he), "he or heat field should be a boolean value!")

    if self.TracerImpactType[tracerName] and not force then
        ErrorNoHalt(tracerName .. " already exists in TracerImpactType. Use force = true to overwrite.\n")
        return 
    end

    self.TracerImpactType[tracerName] = {
        name = ammotype,
        heat = heat,
        he = he
    }
end

--- Get Impact type
function Data:GetImpactType(tracerName)
    assert(isstring(tracerName), "tracerName must be a string!")
    return self.TracerImpactType[tracerName]
end

--// !SECTION

--// SECTION Default Data

--// SECTION [ Default Impact Types ]
local defaultImpactTypes = {
    -- { tracerName, impactName, heat, he }
    { "lvs_tracer_autocannon",           "exp_mid",   true,  false },
    { "lvs_haubitze_trail",              "exp_mid",   false, false },
    { "lvs_haubitze_trail_improved",     "exp_mid",   false, false },
    { "lvs_tracer_cannon",               "exp_large", false, true },
    { "lvs_tracer_cannon_improved",      "exp_large", false, true },
}

for _, entry in ipairs(defaultImpactTypes) do
    Data:AddImpactType(entry)
end

--// !SECTION

--// SECTION [ Default Ammo Types ]
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

--// !SECTION

--// SECTION [ Default Splash Damage Types ]
local defaultSplashTypes = {
    DMG_BLAST,
    DMG_AIRBOAT,
    DMG_SONIC,
}

for _, dmgType in ipairs(defaultSplashTypes) do
    Data:AddValidSplashDamage(dmgType)
end

--// !SECTION

--// !SECTION

RLFX.Data = Data