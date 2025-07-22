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

concommand.Add("test.dlight", function(ply, cmd, args)
    if not IsValid(ply) then return end

    local trace = ply:GetEyeTrace()
    local hitpos = trace.HitPos

    if hitpos then
        RLFX:SendDLight(
            hitpos,
            255, 170, 50,
            8, 2000, 1, 1024
        )
    end
    
end)

function RLFX:EmitVehicleExplosion(pos, normal, ent)
    RLFX:SendDLight(
        pos, 255, 170, 50,
        8, 2000, 1, 1024
    )

    emitParticle({
        pos = pos + normal * 2,
        velocity = VectorRand() * 10,
        color = {255, 160, 80},
        lifetime = 0.4,
        startAlpha = 170,
        endAlpha = 0,
        startSize = 1200,
        endSize = 800,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.vehicle.explosion",
    })

    if IsValid(ent) then
        emitParticle({
            pos = pos + Vector(0, 0, 20) + VectorRand() * 5,
            velocity = Vector(0, 0, 50),
            gravity = Vector(0, 0, 150),
            color = {60, 60, 60},
            lifetime = math.Rand(12.5, 17),
            startAlpha = 150,
            endAlpha = 0,
            startSize = 35,
            endSize = 500,
            effectName = "particle/smokestack",
            airResistance = 15,
            collide = false,
            lighting = true,
            particleID = "rlfx.exp.smoke",
            count = 225, emitRate = 0.1125,
            entityID = ent:EntIndex(),
        })
    end

    for i = 0, 17 do
        local angle = (i / 16) * math.pi * 2
        local dir = Vector(math.cos(angle), math.sin(angle), 0):GetNormalized()
        emitParticle({
            pos = pos + dir * 16 + Vector(0, 0, 20),
            velocity = dir * 150 + Vector(0, 0, 80),
            gravity = Vector(0, 0, 5),
            color = {200, 200, 200},
            lifetime = 7,
            startAlpha = 100,
            endAlpha = 0,
            startSize = 60,
            endSize = 250,
            effectName = "particle/smokestack_nofog",
            airResistance = 15,
            collide = false,
            lighting = true,
            particleID = "rlfx.exp.dust"
        })
    end
end

function RLFX:EmitHERound(pos, normal)
    emitParticle({
        pos = pos + normal * 2,
        velocity = normal * 50,
        color = {255, 160, 80},
        lifetime = 0.15,
        startAlpha = 225,
        endAlpha = 0,
        startSize = 340,
        endSize = 8,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.heround.flash"
    })

    RLFX:SendDLight(
        pos + normal * 2,
        255, 160, 80,
        8, 2000, 1, 1024
    )
end

function RLFX:EmitHEATRound(pos, normal, ent)
    emitParticle({
        pos = pos + normal * 2,
        velocity = Vector(0, 0, 0),
        color = {255, 160, 80},
        lifetime = 0.35,
        startAlpha = 225,
        endAlpha = 0,
        startSize = 120,
        endSize = 8,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.heround.flash"
    })

    emitParticle({
        pos = pos + normal * 2,
        velocity = normal * 50,
        color = {255, 160, 80},
        lifetime = 0.15,
        startAlpha = 225,
        endAlpha = 0,
        startSize = 750,
        endSize = 8,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.heround.flash"
    })

    if IsValid(ent) then
        local rn = math.random
        local rnd = math.Rand
        
        RLFX:SendDLight(
            pos,
            255, rnd(90, 180), rnd(20, 50),
            8, 2000, 1, rnd(128, 512)
        )

        local sparkCount = 24

        if IsAllowedExVFX() then
            sparkCount = 51
        end

        for i = 1, sparkCount do
            local angle = (i / sparkCount) * math.pi * 2
            local dir = (normal * 0.7 + Vector(math.cos(angle), math.sin(angle), rnd(-0.2,0.2)) * 0.7):GetNormalized()
            emitParticle({
                pos = pos + dir * rnd(4, 12),
                velocity = dir * rnd(250, 370) + VectorRand() * 55,
                color = {
                    rn(220, 255),
                    rn(180, 150),
                    rn(40, 120)
                },
                lifetime = rnd(0.45, 1.25),
                startAlpha = 255,
                endAlpha = 0,
                startSize = math.Rand(2.5, 5.5),
                endSize = rnd(0.2, 1.2),
                gravity = Vector(0, 0, -700),
                airResistance = 18,
                effectName = "particle/fire",
                particleID = "rlfx.heat.spark",
                collide = true,
                lighting = false,
                count = 3,
                emitRate = 0.01,
            })
        end
    end
end

function RLFX:EmitShot(pos, normal, startSize, ent, doDust)
    local sSize = isnumber(startSize) and startSize or math.Rand(4, 6)
    sSize = math.max(15, sSize)
    sSize = math.Clamp(sSize, 15, 500)

    emitParticle({
        pos = pos + normal * 2,
        velocity = normal * 50 + VectorRand() * 10,
        color = {255, 160, 80},
        lifetime = 0.15,
        startAlpha = 50,
        endAlpha = 0,
        startSize = 2,
        endSize = sSize * 0.95,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        collide = false,
        effectName = "particle/fire",
        particleID = "rlfx.muzzleflash"
    })

    emitParticle({
        pos = pos + normal * 10,
        velocity = normal * 150,
        color = {255, 160, 80},
        lifetime = 0.05,
        startAlpha = 50,
        endAlpha = 0,
        startSize = sSize * 1.25,
        endSize = 15,
        gravity = Vector(0, 0, 0),
        airResistance = 15,
        effectName = "particle/fire",
        particleID = "rlfx.muzzleflash",
        collide = false,
        count = 7,
        emitRate = 0.0045,
    })

    emitParticle({
        pos = pos + normal * 7.5 + VectorRand() * 1.5,
        velocity = normal * math.Rand(80, 120) + VectorRand() * 150,
        color = {255, 255, 255},
        lifetime = math.Rand(5, 7),
        startAlpha = 20,
        endAlpha = 0,
        startSize = 1,
        endSize = sSize,
        gravity = Vector(0, 0, 0),
        airResistance = 15,
        effectName = "particles/dust",
        particleID = "rlfx.gunshot",
        lighting = true,
        collide = false,
        count = 3,
        emitRate = 0.02
    })

    emitParticle({
        pos = pos + normal * 10,
        velocity = normal * sSize * math.Rand(0.8, 1) + VectorRand() * 5,
        color = {200, 200, 200},
        lifetime = 4,
        startAlpha = 30,
        endAlpha = 0,
        startSize = sSize * 0.25,
        endSize = sSize * 0.5,
        gravity = Vector(0, 0, 0),
        airResistance = 15,
        effectName = "particles/dust1",
        collide = false,
        lighting = true,
        particleID = "rlfx.gunshot",
        count = 10,
        emitRate = 0.02,
    })

    if IsValid(ent) and doDust then
        local up = ent:GetUp()
        local center = ent:GetPos() + up * 10
        local radius = ent:BoundingRadius()
        local count = 3

        for i = 1, count do
            local angle = (i / count) * math.pi * 2
            local dir = Vector(math.cos(angle), math.sin(angle), 0):GetNormalized()

            emitParticle({
                pos = center + dir * radius * 0.35,
                velocity = (dir * radius * 1.15) + normal * radius * math.Rand(1.75, 2.5),
                airResistance = 10,
                lifetime = 10,
                startAlpha = 25,
                gravity = Vector(0, 0, 25),
                endAlpha = 0,
                startSize = radius * 0.25,
                endSize = radius,
                color = {180, 180, 180},
                collide = false,
                lighting = true,
                effectName = "particle/smokestack_nofog",
                particleID = "rlfx.shockwave",
                count = 2,
                emitRate = 0.0075
            })
        end
    end
end

function RLFX:EmitBulletHit(pos, normal, ent)
    if IsValid(ent) then
        emitParticle({
            pos = pos + normal * 2,
            velocity = Vector(0, 0, 0),
            color = {255, 160, 80},
            lifetime = 0.1,
            startAlpha = 225,
            endAlpha = 0,
            startSize = 50,
            endSize = 8,
            gravity = Vector(0, 0, 0),
            airResistance = 5,
            effectName = "particle/fire",
            particleID = "rlfx.heround.flash",
        })

        local rn = math.random
        local rnd = math.Rand
        
        RLFX:SendDLight(
            pos,
            255, rnd(90, 180), rnd(20, 50),
            3, 2000, 1, rnd(128, 512)
        )

        if IsAllowedExVFX() then
            local sparkCount = 12

            for i = 1, sparkCount do
                local angle = (i / sparkCount) * math.pi * 2
                local dir = (normal * 0.7 + Vector(math.cos(angle), math.sin(angle), rnd(-0.2,0.2)) * 0.7):GetNormalized()
                emitParticle({
                    pos = pos + dir * rnd(4, 12),
                    velocity = dir * rnd(250, 370) + VectorRand() * 55,
                    color = {
                        rn(220, 255),
                        rn(180, 150),
                        rn(40, 120)
                    },
                    lifetime = rnd(0.25, 0.85),
                    startAlpha = 255,
                    endAlpha = 0,
                    startSize = math.Rand(2.5, 3.7),
                    endSize = rnd(0.2, 1.2),
                    gravity = Vector(0, 0, -700),
                    airResistance = 18,
                    effectName = "particle/fire",
                    particleID = "rlfx.heat.spark",
                    collide = true,
                    lighting = false,
                    count = 2,
                    emitRate = 0.01,
                })
            end
            return
        end

        emitParticle({
            pos = pos + normal * 2,
            velocity = normal * 800,
            color = {255, 80, 25},
            lifetime = 0.1,
            startAlpha = 225,
            endAlpha = 0,
            startSize = 10,
            endSize = 2,
            gravity = Vector(0, 0, 0),
            airResistance = 5,
            effectName = "particle/fire",
            particleID = "rlfx.heround.flash",
            count = 3,
            emitRate = 0.01,
        })
    else
        if IsAllowedExVFX() then
            emitParticle({
                pos = pos + normal * 2,
                velocity = normal * 50,
                color = {255, 255, 255},
                lifetime = 5,
                startAlpha = 255,
                endAlpha = 0,
                startSize = 5,
                endSize = 50,
                gravity = Vector(0, 0, -25),
                lighting = true,
                airResistance = 5,
                effectName = "particles/dust",
                particleID = "rlfx.bullet.hit",
            })
            for i = 0, 3 do
                emitParticle({
                    pos = pos + normal * 2,
                    velocity = normal * 250 + VectorRand() * 2,
                    color = {255, 255, 255},
                    lifetime = 0.75,
                    startAlpha = 50,
                    endAlpha = 0,
                    startSize = 20,
                    endSize = 1,
                    gravity = Vector(0, 0, -400),
                    lighting = true,
                    airResistance = 5,
                    effectName = "particles/dust",
                    particleID = "rlfx.bullet.hit",
                })
            end
            return
        end 

        emitParticle({
            pos = pos + normal * 2,
            velocity = normal * 50,
            color = {255, 255, 255},
            lifetime = 5,
            startAlpha = 255,
            endAlpha = 0,
            startSize = 5,
            endSize = 50,
            gravity = Vector(0, 0, -25),
            lighting = true,
            airResistance = 5,
            effectName = "particles/dust",
            particleID = "rlfx.bullet.hit",
        })
        emitParticle({
            pos = pos + normal * 2,
            velocity = normal * 150,
            color = {255, 255, 255},
            lifetime = 5,
            startAlpha = 255,
            endAlpha = 0,
            startSize = 5,
            endSize = 50,
            gravity = Vector(0, 0, -150),
            lighting = true,
            airResistance = 5,
            effectName = "particles/dust",
            particleID = "rlfx.bullet.hit",
        })
    end
end