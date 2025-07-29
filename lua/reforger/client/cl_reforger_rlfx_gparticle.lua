GParticleSystem:RegisterCycle("rlfx.heat.sparkles", function(p, i, gp)
    local rnd = math.Rand
    local rn = math.random

    local dir = VectorRand():GetNormalized()

    p:SetVelocity(dir * rnd(300, 480))
    p:SetStartAlpha(255)
    p:SetEndAlpha(0)
    p:SetStartSize(rnd(2.8, 3.8))
    p:SetEndSize(0)
    p:SetGravity(Vector(0, 0, -1000))
    p:SetAirResistance(20)
    p:SetCollide(true)
    p:SetBounce(0.3)
    p:SetLighting(false)

    p:SetColor(
        rn(240, 255),
        rn(140, 170),
        rn(10, 50)
    )
end, true)
