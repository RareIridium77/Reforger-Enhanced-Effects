[back to main](/Readme.md)

## RLFX Custom Sound Caching System

### File: `sh_reforger_rlfx_cacher.lua`  
This file caches custom sounds into `RLFX.CachedSounds`.  

---

### RLFX:RegisterSound(ammoType, zone, path)

Adds custom sound manually from Lua.

#### Params:
- `ammoType` — string (like `"exp_large"`, `"exp_bomb"`, `"MyAmmoType"`)
- `zone` — string (like `"close"`, `"mid"`, `"dist"`, `"far"`)
- `path` — string (starts from `sounds/`, full path to file)

---

### Example
```lua
-- Sound file: sound/yoursounds/MyAmmoType/dist/myexplosion.wav
-- You should register like this:

RLFX:RegisterSound("MyAmmoType", "dist", "sounds/yoursounds/MyAmmoType/dist/myexplosion.wav")
```

### Then to use
```lua
local pos = Vector(0, 0, 0)
local ammotype = "MyAmmoType"
RLFX:EmitSound(pos, ammotype)
```