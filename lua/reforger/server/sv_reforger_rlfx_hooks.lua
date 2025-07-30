
local rfxdata = RLFX.Data
local rfxutil = RLFX.Util

-- LVS bullet fired (initial event)
hook.Add("Reforger.LVS_BulletFired", "RLFX.LVS_BulletFired", function(bullet)
    if not istable(bullet) then return end
    
    local veh = bullet.Entity

    if not IsValid(veh) then
        Reforger.DevLog("LVS Bullet Fired: Invalid vehicle")
        return
    end

    local bsdt = bullet.SplashDamageType
    local btat = bullet.TracerName
    local ammo = rfxdata.TracerAmmoType[btat] or "other"
    RLFX:EmitSound(bullet.Src, ammo)

    if bsdt == DMG_SONIC and not rfxdata.TracerImpactType[btat] then
        if veh.reforgerType == "light" then
            RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.3, veh, false)
        else
            RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.05, veh, false)
        end
        return 
    end

    if bullet.SplashDamageType == DMG_BLAST then
        RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.8, veh, true)
    else
        RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.4, veh, true)
    end
end)

-- LVS bullet hit impact (only for valid splash types)
hook.Add("Reforger.LVS_BulletCallback", "RLFX.LVS_BulletCallback", function(bullet, trace)
    if not (istable(trace) and trace.Hit) then return end

    debugoverlay.Sphere(trace.HitPos + trace.HitNormal * 2, 5, 1, Color(255, 255, 25), true)

    if not rfxdata.ValidSplashDamage[bullet.SplashDamageType] then return end
    
    local bsdt = bullet.SplashDamageType
    local btat = bullet.TracerName

    if bsdt == DMG_SONIC and not rfxdata.TracerImpactType[btat] then
        RLFX:EmitBulletHit(trace.HitPos, trace.HitNormal, trace.Entity)
        return 
    end

    local impact = rfxutil:GetImpactType(bullet, rfxdata.TracerImpactType)
    if not impact then impact = "exp_large" end

    RLFX:EmitSound(trace.HitPos, impact)
    RLFX:EmitHERound(trace.HitPos, trace.HitNormal)
end)

-- LVS Projectiles
hook.Add("Reforger.LVS_ProjectileDetonated", "RLFX.LVS_ProjectileSFX", function(projectile, target, projectileType)
    if not IsValid(projectile) then
        Reforger.DevLog("Projectile is not valid to play sounds")
        return
    end

    local sndType = projectileType == "bomb" and "exp_bomb" or "25mm"
    Reforger.DevLog("Projectile Detonated")
    RLFX:EmitSound(projectile:GetPos(), sndType)
end)

hook.Add("Reforger.LVS_ProjectileActivated", "RLFX.LVS_MissileSFX", function(missile, projectileType)
    Reforger.DevLog("Projectile Launched. Is Type "..projectileType)

    if projectileType == "bomb" then return end

    RLFX:EmitSound(missile:GetPos(), "start_missile")
end)

hook.Add("Reforger.LVS_Exploded", "RLFX.LVS_DestructionSFX", function(lvs)
    if not IsValid(lvs) and lvs.reforgerExploded  then return end

    RLFX:EmitSound(lvs:GetPos(), "tank_explosion")

    local pos = lvs:GetPos()
    local normal = lvs:GetUp()

    RLFX:EmitVehicleExplosion(pos, normal, lvs)
    Reforger.DevLog("VehicleExplosion from", lvs, "is valid:", IsValid(lvs), "at", pos)
end)

concommand.Add("test_emit_explosion", function(ply, cmd)
    local tr = ply:GetEyeTrace()

    if tr.Hit then
        RLFX:EmitSound(tr.HitPos, "exp_large")
        RLFX:EmitVehicleExplosion(tr.HitPos, tr.HitNormal, tr.Entity)
    end
end)

concommand.Add("test_emit_rlfx", function(ply, cmd, args)
    if not IsValid(ply) then return end

    local kv = {}
    local i = 1

    while i <= #args do
        local key = args[i]
        local value = args[i + 1]

        if not key then break end

        if key == "pos" and args[i+1] and args[i+2] and args[i+3] then
            kv.pos = Vector(tonumber(args[i+1]) or 0, tonumber(args[i+2]) or 0, tonumber(args[i+3]) or 0)
            i = i + 4
        else
            kv[key] = value
            i = i + 2
        end
    end

    local pos = kv.pos or ply:GetPos()
    local ammotype = kv.ammotype or "25mm"
    local zone = kv.zone or nil
    local delay = tonumber(kv.delay) or 0.2
    local count = tonumber(kv.count) or 10

    if not RLFX.Net.IsValidAMT(ammotype) then
        ply:ChatPrint("[RLFX] Неверный тип боеприпаса: " .. tostring(ammotype))
        return
    end

    for i = 1, count do
        timer.Simple(i * delay, function()
            RLFX:EmitSound(pos, ammotype, zone)
        end)
    end

    ply:ChatPrint(("[RLFX] Эмит: %s, зона: %s, %d повторов"):format(ammotype, zone or "auto", count))
end)
