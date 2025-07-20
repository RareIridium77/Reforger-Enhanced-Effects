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
RLFX.Data.TracerAmmoType = {
    ["lvs_tracer_autocannon"]     = "25mm",
    -- mid
    ["lvs_haubitze_trail"] = "exp_mid",
    ["lvs_haubitze_trail_improved"] = "exp_mid",
    -- cannons
    ["lvs_tracer_cannon"]     = "tank_fire",
    ["lvs_tracer_cannon_improved"]     = "tank_fire",
}

RLFX.Data.TracerImpactType = {
    ["lvs_tracer_autocannon"]     = "exp_mid",
    -- mid
    ["lvs_haubitze_trail"] = "exp_mid",
    ["lvs_haubitze_trail_improved"] = "exp_mid",
    -- cannons
    ["lvs_tracer_cannon"]     = "exp_large",
    ["lvs_tracer_cannon_improved"]     = "exp_large",
}

RLFX.Data.ValidSplashDamage = {
    [DMG_BLAST]   = true,
    [DMG_AIRBOAT] = true,
    [DMG_SONIC]   = true,
}
