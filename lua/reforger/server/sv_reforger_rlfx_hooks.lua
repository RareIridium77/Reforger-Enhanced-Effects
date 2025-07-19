
local rfxdata = RLFX.Data
local rfxutil = RLFX.Util

-- LVS bullet fired (initial event)
hook.Add("Reforger.LVS_BulletFired", "RLFX.LVS_BulletFired", function(bullet)
    local ammo = "other"
    local veh = bullet.Entity

    if IsValid(veh) then
        if veh.reforgerType == "plane" or veh.reforgerType == "helicopter" then
            RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.012, bullet.Entity, false) 
        elseif veh.reforgerType == "armored" then
            RLFX:EmitShot(bullet.Src, bullet.StartDir, bullet.Force * 0.04, bullet.Entity, bullet.Force >= 500)
        end
    end

    if bullet.TracerName == "lvs_tracer_missile" then
        ammo = "start_missile"
    end

    if ammo == "other" then
        ammo = rfxdata.TracerAmmoType[bullet.TracerName]
        if not ammo then ammo = "other" end
    end

    RLFX:EmitSound(bullet.Src, ammo)
end)

-- LVS bullet hit impact (only for valid splash types)
hook.Add("Reforger.LVS_BulletCallback", "RLFX.LVS_BulletCallback", function(bullet, trace)
    if not (istable(trace) and trace.Hit) then return end
    if not rfxdata.ValidSplashDamage[bullet.SplashDamageType] then return end
    
    local bsdt = bullet.SplashDamageType
    local btat = bullet.TracerName

    if bsdt == DMG_SONIC and not rfxdata.TracerImpactType[btat] then return end

    local impact = rfxutil:GetImpactType(bullet, rfxdata.TracerImpactType)
    if not impact then return end

    if bullet.SplashDamageType == DMG_BLAST then
        RLFX:EmitHERound(trace.HitPos, trace.HitNormal)
    end

    Reforger.DevLog("Bullet Callback")

    RLFX:EmitSound(trace.HitPos, impact)
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
    if not IsValid(lvs) then return end
    RLFX:EmitSound(lvs:GetPos(), "tank_explosion")

    local pos = lvs:GetPos()
    local normal = lvs:GetUp()
    local ent = lvs

    timer.Simple(1, function()
        if not IsValid(ent) then return end
        RLFX:EmitVehicleExplosion(pos, normal, ent)
        print("VehicleExplosion from", ent, "is valid:", IsValid(ent), "at", pos)
    end)
end)

concommand.Add("test_emit_explosion", function(ply, cmd)
    local tr = ply:GetEyeTrace()

    if tr.Hit then
        RLFX:EmitVehicleExplosion(tr.HitPos, tr.HitNormal, tr.Entity)
    end
end)

concommand.Add("test_emit_rlfx", function(ply, cmd, args)
    if not IsValid(ply) then return end

    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    local ammotype = args[4] or "25mm"

    if not (x and y and z) then
        ply:ChatPrint("[RLFX] Неверные координаты. Используй: test_emit_rlfx <x> <y> <z> [ammotype]")
        return
    end

    local pos = Vector(x, y, z)

    if not RLFX.Net.IsValidAMT(ammotype) then
        ply:ChatPrint("[RLFX] Недопустимый тип звука: " .. tostring(ammotype))
        return
    end

    RLFX:EmitSound(pos, ammotype)
    ply:ChatPrint("[RLFX] Тестовый выстрел отправлен: " .. ammotype)
end)
