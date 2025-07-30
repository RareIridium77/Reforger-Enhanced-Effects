GParticleSystem:RegisterCycle("rlfx.heat.sparkles", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random
    local count = gp:GetCount()
    local normal = gp:GetNormal()
    local frac = (i / count)
    local dir = VectorRand()

    if frac >= 0.5 then
        p:SetVelocity(dir * 20)
        p:SetCollide(false)
    else
        p:SetVelocity(normal * 250 + dir * rnd(20, 100))
        p:SetCollide(true)
    end

    p:SetStartAlpha(255)
    p:SetEndAlpha(0)
    p:SetStartSize(rnd(4, 7))
    p:SetEndSize(0)
    p:SetGravity(Vector(0, 0, -1000))
    p:SetAirResistance(20)
    p:SetBounce(0.3)
    p:SetLighting(false)
    p:SetCollideCallback(function(particle, hitPos, hitNormal)
        particle:SetPos(hitPos + normal * 0.5)
    end)

    p:SetColor(
        rn(240, 255),
        rn(125, 160),
        rn(10, 50)
    )
end, true)

GParticleSystem:RegisterCycle("rlfx.explosion.small", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random
    local count = gp:GetCount() or 20
    local frac = i / count -- 0..1

    local dir = VectorRand():GetNormalized()
    local speed = rnd(150, 300) * (0.8 + frac * 0.4)
    p:SetVelocity(dir * speed)

    p:SetStartAlpha(240 * (1 - frac * 0.3))
    p:SetEndAlpha(0)

    p:SetStartSize(rnd(150, 200) * (1 + frac * 0.5))
    p:SetEndSize(rnd(60, 90))

    p:SetAirResistance(rnd(60, 90))
    p:SetGravity(Vector(0, 0, rnd(20, 60) * (1 - frac * 0.5)))

    local r = 255
    local g = 170 + (85 * frac)
    local b = 20 + (235 * frac)

    p:SetColor(math.Clamp(r, 0, 255), math.Clamp(g, 0, 255), math.Clamp(b, 0, 255))
    p:SetLighting(false)
end, true)

GParticleSystem:RegisterCycle("rlfx.explosion.dust.air", function(p, i, gp)
    local rnd = math.Rand
    local count = gp:GetCount() or 20
    local frac = i / count
    local dir = VectorRand():GetNormalized()

    local speed = rnd(100, 250)
    p:SetVelocity(dir * speed)

    local startSize = rnd(50, 150)
    local endSize = rnd(60, 80)

    if frac >= 0.8 then
        startSize = startSize * 1.1
        endSize = endSize * 1.4
        p:SetStartAlpha(80)
        p:SetGravity(Vector(0, 0, rnd(5, 15)))
        p:SetColor(90, 90, 90)
    else
        p:SetStartSize(startSize * 5)
        p:SetStartAlpha(50)
        p:SetGravity(Vector(0, 0, rnd(0, 15)))
        p:SetVelocity(dir * speed)
        p:SetColor(30, 30, 30)
    end

    p:SetStartSize(startSize)
    p:SetEndSize(endSize)

    p:SetAirResistance(100)
    p:SetEndAlpha(0)
    p:SetLighting(false)
end, true)

GParticleSystem:RegisterCycle("rlfx.explosion.dust", function(p, i, gp)
    local rnd = math.Rand
    local count = gp:GetCount() or 20
    local frac = i / count
    local dir = VectorRand():GetNormalized()
    dir.z = math.abs(dir.z * 0.3)

    local speed = rnd(250, 550)

    local startSize = rnd(25, 35)
    local endSize = rnd(70, 90)

    if frac >= 0.8 then
        startSize = startSize * 1.4
        endSize = endSize * 1.7
        p:SetStartAlpha(100)
        p:SetGravity(Vector(0, 0, rnd(-20, -80)))
        p:SetVelocity(dir * speed / 2)
        p:SetStartSize(startSize)
        p:SetColor(80, 80, 80)
    else
        p:SetStartSize(startSize * 5)
        p:SetStartAlpha(50)
        p:SetGravity(Vector(0, 0, rnd(0, 15)))
        p:SetVelocity(dir * speed)
        p:SetColor(30, 30, 30)
    end

    p:SetEndSize(endSize)

    p:SetAirResistance(120)
    p:SetEndAlpha(0)
    p:SetLighting(false)
end, true)

GParticleSystem:RegisterCycle("rlfx.shot.muzzle", function(p, i, gp)
    local rnd = math.Rand
    local normal = gp:GetNormal()

    p:SetVelocity(normal * rnd(50, 100) + VectorRand() * 10)
    p:SetStartAlpha(100)
    p:SetEndAlpha(0)
    p:SetStartSize(rnd(120, 150))
    p:SetEndSize(rnd(20, 40))
    p:SetDieTime(rnd(2.5, 3.5))
    p:SetAirResistance(60)
    p:SetGravity(Vector(0, 0, 20))
    p:SetColor(80, 80, 80)
    p:SetLighting(true)
end, true)

GParticleSystem:RegisterCycle("rlfx.shot.dust", function(p, i, gp)
    local rnd = math.Rand
    local pos = gp:GetPos()
    local normal = gp:GetNormal()

    p:SetVelocity(VectorRand():GetNormalized() * rnd(40, 90) + normal * 30)
    p:SetStartAlpha(90)
    p:SetEndAlpha(0)
    p:SetStartSize(rnd(3, 6))
    p:SetEndSize(rnd(10, 18))
    p:SetDieTime(rnd(1.2, 1.8))
    p:SetAirResistance(40)
    p:SetGravity(Vector(0, 0, 10))
    p:SetColor(120, 110, 90)
    p:SetLighting(true)
end, true)

GParticleSystem:RegisterCycle("rlfx.vehicle.explosion", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random
    local count = gp:GetCount() or 60
    local frac = i / count
    local dir = VectorRand():GetNormalized()

    local baseHeight = 80
    local midHeight = 60
    local topHeight = 40

    local baseSize = {min = 200, max = 500}
    local midSize = {min = 70, max = 100}
    local topSize = {min = 200, max = 500}

    local baseEndSize = {min = 160, max = 200}
    local midEndSize = {min = 90, max = 140}
    local topEndSize = {min = 160, max = 250}

    local baseDie = {min = 0.1, max = 0.25}
    local midDie = {min = 1.2, max = 2.2}
    local topDie = {min = 0.8, max = 1.5}

    if frac < 0.5 then
        p:SetVelocity(dir * rnd(120, 220))
        p:SetStartAlpha(255)
        p:SetEndAlpha(0)
        p:SetStartSize(rnd(baseSize.min, baseSize.max))
        p:SetEndSize(rnd(baseEndSize.min, baseEndSize.max))
        p:SetDieTime(rnd(baseDie.min, baseDie.max))
        p:SetColor(rn(240, 255), rn(100, 140), rn(10, 30))
        p:SetGravity(Vector(0, 0, baseHeight))
    elseif frac < 0.8 then
        dir.z = math.abs(dir.z) * 5
        p:SetVelocity(dir * rnd(60, 100))
        p:SetStartAlpha(220)
        p:SetEndAlpha(0)
        p:SetStartSize(rnd(midSize.min, midSize.max))
        p:SetEndSize(rnd(midEndSize.min, midEndSize.max))
        p:SetColor(rn(230, 255), rn(190, 220), rn(60, 80))
        p:SetDieTime(rnd(midDie.min, midDie.max))
        p:SetGravity(Vector(0, 0, midHeight))
    else
        dir.z = math.abs(dir.z) * 5
        p:SetVelocity(dir * rnd(40, 90) + Vector(0, 0, baseHeight + midHeight + topHeight))
        p:SetStartAlpha(160)
        p:SetEndAlpha(0)
        p:SetStartSize(rnd(topSize.min, topSize.max))
        p:SetEndSize(rnd(topEndSize.min, topEndSize.max))
        p:SetDieTime(rnd(topDie.min, topDie.max))
        p:SetColor(rn(230, 255), rn(190, 220), rn(60, 80))
        p:SetGravity(Vector(0, 0, baseHeight + midHeight + topHeight))
    end

    p:SetAirResistance(rnd(30, 70))
    p:SetLighting(false)
end, true)

GParticleSystem:RegisterCycle("rlfx.vehicle.smoke", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random

    local count = gp:GetCount() or 40
    local frac = i / count
    local dir = VectorRand():GetNormalized()

    p:SetStartAlpha(255)
    p:SetEndAlpha(0)
    p:SetStartSize(rnd(20, 70))
    p:SetEndSize(rnd(300, 450))
    
    local gray = rn(30, 60)
    p:SetColor(gray, gray, gray)

    p:SetGravity(Vector(0, 0, rnd(150, 250)))
    p:SetAirResistance(rnd(20, 60))
    p:SetLighting(false)

    if frac > 0.8 then
        local bright = rn(70, 100)
        p:SetColor(bright, bright, bright)
    end
end, true)

GParticleSystem:RegisterCycle("rlfx.vehicle.fire", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random

    local count = gp:GetCount() or 40
    local frac = i / count
    local dir = VectorRand():GetNormalized()
    dir.z = math.abs(dir.z) * 2

    local r = 255
    local g = 255
    local b = 255

    if rn(1, 5) == 1 then
        p:SetStartAlpha(255)
        p:SetStartSize(rnd(4, 8))
        p:SetDieTime(rnd(0.2, 0.4))
        p:SetVelocity(dir * rnd(100, 200))
        p:SetColor(255, rn(180, 220), rn(50, 80))
        p:SetGravity(Vector(0, 0, -400))
        p:SetEndSize(0)
    else
        p:SetStartAlpha(rnd(150, 175))
        p:SetStartSize(rnd(15, 25))
        p:SetDieTime(rnd(0.6, 1.7))
        p:SetVelocity(Vector(0, 0, rnd(35, 45))) -- 🔻 медленнее
        p:SetColor(r, g, b)
        p:SetGravity(Vector(0, 0, 10)) -- 🔻 медленнее подъём
        p:SetEndSize(8)
    end

    p:SetEndAlpha(0)
    p:SetAirResistance(rnd(30, 60))
    p:SetLighting(false)
end, true)
