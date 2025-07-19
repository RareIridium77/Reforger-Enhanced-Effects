[back to main](/Readme.md)

## RLFX Sound Utils

### File: [sv_reforger_rlfx_utils.lua](./sv_reforger_rlfx_utils.lua)  
Internal utilities for RLFX - used to calculate sound delays, obstruction and determine impact type.

---

### RLFX.Util:GetSoundDelay(distance, csp, altitude)

Returns delay in seconds between explosion and sound, based on distance and altitude.  
Uses Source engine audio physics (losing ~6 m/s every 150m height).

#### Params:
- `distance` — number (distance from listener to explosion)
- `csp` — number (current sound speed, usually `340`)
- `altitude` — number (optional height in meters)

#### Example:
```lua
local distance = 4000
local csp = 340 -- current sound delay
local altitude = 500
local delay = RLFX.Util:GetSoundDelay(distance, csp, altitude)
```

### RLFX.Util:IsObstructed(startPos, endPos)

Returns boolean that is startPos and endPos obstructed or not.

#### Params:
- `startPos` — Vector (start position, for example sound pos)
- `endPos` — Vector (end pos, for example listener pos)

#### Example:
```lua
local soundPos = Vector(0, 0, 0) -- sound position for example
local listenerPos = Entity(1):EyePos() -- get first players eye pos as listener pos (https://wiki.facepunch.com/gmod/Global.Entity)
if RLFX.Util:IsObstructed(soundPos, listenerPos) then
    -- DO SOMETHING
end
```

### RLFX.Util:GetImpactType(bullet, atypedata)

not documentation right now.