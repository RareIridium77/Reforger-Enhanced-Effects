[back to main](/Readme.md)

## RLFX Sound Effects

### File: [sv_reforger_rlfx_sfx.lua](./sv_reforger_rlfx_sfx.lua)  
This file created method to send RLFX sound effects by `position` and `ammotype`  

## Example
```lua
local pos = Vector(0, 0, 0)
local ammotype = "exp_large"
RLFX:EmitSound(pos, ammotype)
```  
Creates `exp_large` ammotype sound effect at the origin (0, 0, 0)