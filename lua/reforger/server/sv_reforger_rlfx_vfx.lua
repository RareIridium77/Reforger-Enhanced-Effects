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

    emitParticle({
        pos = pos,
        particleID = "rlfx.heat.sparkles",
        effectName = "particle/fire",
        count = 150,
        repeatCount = 3,
        repeatDelay = 0.1,
    })
end)

function RLFX:EmitSparkles(pos, normal, count)
    emitParticle({
        pos = pos,
        particleID = "rlfx.heat.sparkles",
        effectName = "particle/fire",
        count = count or 100,
        repeatCount = 2,
        repeatDelay = 0.005,
    })
end

function RLFX:EmitVehicleExplosion(pos, normal, ent)
    RLFX:SendDLight(pos, 255,170,50, 8,2000,1,1024)
end

function RLFX:EmitHERound(pos, normal)
    RLFX:SendDLight(pos + normal * 2, 255, 160, 80, 10, 2000, 1, 768)
end

function RLFX:EmitHEATRound(pos, normal, ent)
    RLFX:EmitSparkles(pos, normal, 25)
    if IsValid(ent) then
        RLFX:SendDLight(pos, 255, 100, 40, 8, 2000, 1, 512)
    end
end

function RLFX:EmitShot(pos, normal, startSize, ent, doDust)
    
end

function RLFX:EmitBulletHit(pos, normal, ent)
    RLFX:EmitSparkles(pos, normal, 15)

    if IsValid(ent) then
        RLFX:SendDLight(pos, 255, 100, 40, 4, 2000, 1, 384)
    end
end