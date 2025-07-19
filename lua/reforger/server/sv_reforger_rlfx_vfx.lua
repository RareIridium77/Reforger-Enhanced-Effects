RLFX = RLFX or {}

local function emitParticle(data) -- guard me please. I'm scared
    if GParticleSystem then
        GParticleSystem:Emit(data)
    end
end

function RLFX:EmitVehicleExplosion(pos, normal, ent)
    emitParticle({
        pos = pos + normal * 2,
        velocity = VectorRand() * 10,
        color = {255, 160, 80},
        lifetime = 0.2,
        startAlpha = 170,
        endAlpha = 0,
        startSize = 1000,
        endSize = 800,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.muzzleflash",
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
        startSize = 24,
        endSize = 8,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        effectName = "particle/fire",
        particleID = "rlfx.heround.flash"
    })

    for i = 0, 11 do
        local angle = (i / 12) * math.pi * 2
        local dir = Vector(math.cos(angle), math.sin(angle), 0):GetNormalized()
        emitParticle({
            pos = pos + dir * 6 + normal * 4,
            velocity = dir * 200 + normal * 150,
            color = {255, 180, 80},
            lifetime = 1.0,
            startAlpha = 255,
            endAlpha = 20,
            startSize = 8,
            endSize = 2,
            gravity = Vector(0, 0, -400),
            airResistance = 30,
            effectName = "particles/dust",
            particleID = "rlfx.heround"
        })
    end
end

function RLFX:EmitHEATRound(pos, normal)
    for i = 0, 7 do
        local angle = (i / 8) * math.pi * 2
        local dir = Vector(math.cos(angle), math.sin(angle), 0):GetNormalized()
        emitParticle({
            pos = pos + dir * 4 + normal * 2,
            velocity = dir * 300 + normal * 250,
            color = {255, 100, 30},
            lifetime = 0.85,
            startAlpha = 230,
            endAlpha = 10,
            startSize = 7,
            endSize = 1,
            gravity = Vector(0, 0, -300),
            airResistance = 20,
            effectName = "particles/flamelet",
            particleID = "rlfx.heatrnd"
        })
    end
end

function RLFX:EmitShot(pos, normal, startSize, ent, doDust)
    local sSize = isnumber(startSize) and startSize or math.Rand(4, 6)
    sSize = math.max(15, sSize)
    sSize = math.Clamp(sSize, 15, 500)

    emitParticle({
        pos = pos + normal * 2,
        velocity = VectorRand() * 10,
        color = {255, 160, 80},
        lifetime = 0.15,
        startAlpha = 170,
        endAlpha = 0,
        startSize = sSize * 1.9,
        endSize = sSize * 1.2,
        gravity = Vector(0, 0, 0),
        airResistance = 5,
        collide = false,
        effectName = "particle/fire",
        particleID = "rlfx.muzzleflash"
    })

    emitParticle({
        pos = pos + normal * 10,
        velocity = normal * startSize * 1.5,
        color = {255, 160, 80},
        lifetime = 0.075,
        startAlpha = 255,
        endAlpha = 0,
        startSize = sSize * 1.5,
        endSize = 1,
        gravity = Vector(0, 0, 0),
        airResistance = 15,
        effectName = "particle/fire",
        particleID = "rlfx.muzzleflash",
        collide = false,
        count = 4,
        emitRate = 0.0045,
    })

    for i = 1, 2 do
        emitParticle({
            pos = pos + normal * 7.5 + VectorRand() * 1.5,
            velocity = normal * math.Rand(80, 120) + VectorRand() * 40,
            color = {200, 200, 200, 5},
            lifetime = math.Rand(5, 7),
            startAlpha = 30,
            endAlpha = 0,
            startSize = 1,
            endSize = sSize,
            gravity = Vector(0, 0, 0),
            airResistance = 15,
            effectName = "particles/dust",
            particleID = "rlfx.gunshot",
            lighting = true,
            collide = false,
            count = 7,
            emitRate = 0.02
        })
    end

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
        local count = 5

        for i = 1, count do
            local angle = (i / count) * math.pi * 2
            local dir = Vector(math.cos(angle), math.sin(angle), 0):GetNormalized()

            emitParticle({
                pos = center + dir * radius * 0.35,
                velocity = (dir * radius * 1.15) + normal * radius * math.Rand(1.75, 2.5),
                airResistance = 10,
                lifetime = 10,
                startAlpha = 12.5,
                endAlpha = 0,
                startSize = 50,
                endSize = radius,
                color = {180, 180, 180},
                collide = false,
                lighting = true,
                effectName = "particle/smokestack_nofog",
                particleID = "rlfx.shockwave",
                count = 8,
                emitRate = 0.0075
            })
        end
    end
end
