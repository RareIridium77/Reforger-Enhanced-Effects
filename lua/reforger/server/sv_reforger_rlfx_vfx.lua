RLFX = RLFX or {}

local allowExtendedEffects = Reforger.CreateConvar(
    "rlfx.allow.exEffects", "1",
    "Extended effects for RLFX. 0 - disable, 1 - enable",
    0, 1
)

local function IsAllowedExVFX()
    return allowExtendedEffects:GetBool() == true
end

local function emitParticle(data) -- guard me please. I'm scared
    if GParticleSystem then
        GParticleSystem:Emit(data)
    end
end

util.AddNetworkString("rlfx.dlight")

function RLFX:SendDLight(pos, r, g, b, brightness, decay, delay, size)
    net.Start("rlfx.dlight")
    net.WriteUInt(math.random(0, 65535), 16)
    net.WriteVector(pos)
    net.WriteUInt(r, 8)
    net.WriteUInt(g, 8)
    net.WriteUInt(b, 8)
    net.WriteFloat(brightness)
    net.WriteFloat(decay, 16)
    net.WriteFloat(delay, 16)
    net.WriteFloat(size, 16)
    net.Broadcast()
end

concommand.Add("test.dlight", function(ply)
    if not IsValid(ply) then return end
    local tr = ply:GetEyeTrace()
    local pos = tr.HitPos + tr.HitNormal * 2

    RLFX:SendDLight(pos, 255,170,50, 8,2000,1,112)
end)

function RLFX:EmitSparkles(pos, normal, count)
    emitParticle({
        pos = pos + normal * 10,
        lifetime = math.Rand(0.35, 15),
        particleID = "rlfx.heat.sparkles",
        effectName = "particle/particle_glow_05_addnofog",
        count = count or 100,
        repeatCount = 2,
        repeatDelay = 0.005,
    })
end

function RLFX:EmitVehicleExplosion(pos, normal, ent)
    local entIndex = nil

    if IsValid(ent) then
        entIndex = ent:EntIndex()
    end

    RLFX:SendDLight(pos, 255,170,50, 8,2000,1,1024)
    emitParticle({
        pos = pos,
        particleID = "rlfx.vehicle.explosion",
        effectName = "particle/particle_glow_04_additive",
        normal = normal,
        count = 5,
        emitRate = 0.01,
    })
    emitParticle({
        pos = pos,
        lifetime = 20,
        particleID = "rlfx.vehicle.smoke",
        effectName = "particle/particle_smokegrenade1",
        normal = normal,
        count = 100,
        emitRate = 0.25,
        repeatCount = 1,
        entityID = entIndex
    })
    
    local fireTextures = {"sprites/flamelet1", "sprites/flamelet2", "sprites/flamelet3", "sprites/flamelet4", "sprites/flamelet5"}

    for i = 1, 5 do
        emitParticle({
            pos = pos,
            lifetime = 20,
            particleID = "rlfx.vehicle.fire",
            effectName = fireTextures[i],
            normal = normal,
            count = 16, -- 🔻 меньше частиц
            emitRate = 0.1 + i * 0.01, -- 🔄 чуть разнесены во времени
            repeatCount = 4,           -- 🔄 чуть дольше, но реже
            repeatDelay = 0.03,
            entityID = entIndex
        })
    end
end

function RLFX:EmitHERound(pos, normal)
    local tr = util.TraceLine({
        start = pos,
        endpos = pos - normal * 64,
        mask = MASK_SOLID_BRUSHONLY
    })

    local dustType = tr.Hit and "" or ".air"
    local dustParticleID = "rlfx.explosion.dust" .. dustType

    RLFX:SendDLight(pos + normal * 2, 255, 160, 80, 10, 2000, 1, 768)

    emitParticle({
        pos = pos,
        particleID = "rlfx.explosion.small",
        lifetime = 0.24,
        effectName = "particle/particle_glow_04_additive",
        normal = normal,
        count = 16,
        emitRate = 0,
    })

    emitParticle({
        pos = pos,
        particleID = dustParticleID,
        lifetime = 10,
        effectName = "particle/particle_noisesphere",
        normal = normal,
        count = 100,
    })
end

function RLFX:EmitHEATRound(pos, normal, ent)
    RLFX:EmitSparkles(pos, normal, 120)

    debugoverlay.Sphere(pos, 10, 4, Color(255, 2, 2), true)
    debugoverlay.Text(pos + Vector(0, 0, 20), "HEAT", 5, false)

    if IsValid(ent) then
        RLFX:SendDLight(pos, 255, 100, 40, 8, 2000, 1, 512)
    end
end


function RLFX:EmitShot(pos, normal, startSize, ent, doDust)
    emitParticle({
        pos = pos + normal * 5,
        particleID = "rlfx.shot.muzzle",
        effectName = "particle/particle_glow_04_additive",
        normal = normal,
        count = 6,
    })

    if doDust then
        emitParticle({
            pos = pos + normal * 5,
            particleID = "rlfx.shot.dust",
            effectName = "particle/particle_smokegrenade",
            normal = normal,
            count = 4,
        })
    end
end

function RLFX:EmitBulletHit(pos, normal, ent)
    emitParticle({
        pos = pos + normal * 5,
        particleID = "rlfx.shot.dust",
        effectName = "particle/particle_glow_04_additive",
        normal = normal,
        count = 3,
    })

    if IsValid(ent) then
        RLFX:EmitSparkles(pos, normal, 5)
        RLFX:SendDLight(pos, 255, 100, 40, 4, 2000, 1, 384)
    end
end