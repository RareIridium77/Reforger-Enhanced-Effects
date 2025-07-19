RLFX = RLFX or {}

local function CacheSound(ammotype, zone, path)
    if not (isstring(path) and isstring(ammotype) and isstring(zone)) then return end

    self.CachedSounds[ammotype] = self.CachedSounds[ammotype] or {}
    self.CachedSounds[ammotype][zone] = self.CachedSounds[ammotype][zone] or {}

    table.insert(self.CachedSounds[ammotype][zone], path)
    util.PrecacheSound(path)
end

function RLFX:RegisterSound(ammotype, zone, path)
    assert(isstring(ammotype), "ammotype must be a string")
    assert(isstring(zone),     "zone must be a string")
    assert(isstring(path),     "path must be a string")

    CacheSound(ammotype, zone, path)
end

local function CollectAllSounds(tbl, out)
    out = out or {}

    for _, v in pairs(tbl) do
        if istable(v) then
            CollectAllSounds(v, out)
        elseif isstring(v) then
            table.insert(out, v)
        end
    end

    return out
end

hook.Add("PostGamemodeLoaded", "RLFX.PrecacheSounds", function()
    local allSounds = CollectAllSounds(RLFX.CachedSounds)

    for _, snd in ipairs(allSounds) do
        util.PrecacheSound(snd)
    end
    
    print("[RLFX] Cached " .. #allSounds .. " sounds.")
end)
