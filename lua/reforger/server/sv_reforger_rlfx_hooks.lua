local rfxdata = RLFX.Data
local rfxutil = RLFX.Util

--- [ LVS Bullet Fired ] ---
hook.Add("Reforger.LVS_BulletFired", "RLFX.LVS_BulletFired", function(bullet)
    if not istable(bullet) then return end
    
    local veh = bullet.Entity

    if not IsValid(veh) then return end

    local ammoType = rfxdata.TracerAmmoType[bullet.TracerName] or "other"
    RLFX:EmitSound(bullet.Src, ammoType)

    local isLight = veh.reforgerType == "light"
    local isSonic = bullet.SplashDamageType == DMG_SONIC and not rfxdata.TracerImpactType[bullet.TracerName]

    if isSonic then
        local power = isLight and 0.3 or 0.05
        RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * power, veh, false)
        return
    end

    local power = (bullet.SplashDamageType == DMG_BLAST) and 0.8 or 0.4
    RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * power, veh, true)
end)

--- [ LVS Bullet Hit ] ---
hook.Add("Reforger.LVS_BulletCallback", "RLFX.LVS_BulletCallback", function(bullet, trace)
    if not (istable(trace) and trace.Hit) then return end
    if not rfxdata.ValidSplashDamage[bullet.SplashDamageType] then return end

    debugoverlay.Sphere(trace.HitPos + trace.HitNormal * 2, 5, 1, Color(255, 255, 25), true)

    local impact = rfxdata.TracerImpactType[bullet.TracerName]
    local isSonic = bullet.SplashDamageType == DMG_SONIC and not impact

    if isSonic then
        RLFX:EmitBulletHit(trace.HitPos, trace.HitNormal, trace.Entity)
        return
    end

    if impact and impact.he then
        RLFX:EmitHERound(trace.HitPos, trace.HitNormal)
    else
        RLFX:EmitHEATRound(trace.HitPos, trace.HitNormal, trace.Entity)
    end

    RLFX:EmitSound(trace.HitPos, impact.name)
end)

--- [ LVS Projectile Detonated ] ---
hook.Add("Reforger.LVS_ProjectileDetonated", "RLFX.LVS_ProjectileSFX", function(projectile, _, projectileType)
    if not IsValid(projectile) then return end
    local snd = (projectileType == "bomb") and "exp_bomb" or "25mm"
    RLFX:EmitSound(projectile:GetPos(), snd)
end)

--- [ LVS Missile Launched ] ---
hook.Add("Reforger.LVS_ProjectileActivated", "RLFX.LVS_MissileSFX", function(missile, projectileType)
    if projectileType ~= "bomb" then
        RLFX:EmitSound(missile:GetPos(), "start_missile")
    end
end)

--- [ LVS Vehicle Exploded ] ---
hook.Add("Reforger.LVS_Exploded", "RLFX.LVS_DestructionSFX", function(lvs)
    if not IsValid(lvs) or not lvs.reforgerExploded then return end

    local pos = lvs:GetPos()
    RLFX:EmitSound(pos, "tank_explosion")
    RLFX:EmitVehicleExplosion(pos, lvs:GetUp(), lvs)
end)

--- [ TEST COMMANDS ] ---
concommand.Add("test_emit_explosion", function(ply)
    local tr = ply:GetEyeTrace()
    if not tr.Hit then return end

    RLFX:EmitSound(tr.HitPos, "exp_large")
    RLFX:EmitVehicleExplosion(tr.HitPos, tr.HitNormal, tr.Entity)
end)

concommand.Add("test_emit_rlfx", function(ply, _, args)
    if not IsValid(ply) then return end

    local kv = {}
    local i = 1
    while i <= #args do
        local key = args[i]
        local value = args[i + 1]

        if key == "pos" and args[i+1] and args[i+2] and args[i+3] then
            kv.pos = Vector(tonumber(args[i+1]) or 0, tonumber(args[i+2]) or 0, tonumber(args[i+3]) or 0)
            i = i + 4
        else
            kv[key] = value
            i = i + 2
        end
    end

    local pos = kv.pos or ply:GetPos()
    local ammo = kv.ammotype or "25mm"
    local zone = kv.zone
    local delay = tonumber(kv.delay) or 0.2
    local count = tonumber(kv.count) or 10

    if not RLFX.Net.IsValidAMT(ammo) then
        ply:ChatPrint("[RLFX] Неверный тип боеприпаса: " .. tostring(ammo))
        return
    end

    for i = 1, count do
        timer.Simple(i * delay, function()
            RLFX:EmitSound(pos, ammo, zone)
        end)
    end

    ply:ChatPrint(("[RLFX] Эмит: %s, зона: %s, %d повторов"):format(ammo, zone or "auto", count))
end)
