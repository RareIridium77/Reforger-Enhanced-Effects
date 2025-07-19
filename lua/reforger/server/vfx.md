[back to main](/Readme.md)

## RLFX Visual Effects

### File: [sv_reforger_rlfx_vfx.lua](./sv_reforger_rlfx_vfx.lua)  
This file created method to send RLFX visual effects that includes [Gmod-Particle-System](https://github.com/RareIridium77/Gmod-Particle-System)

---

### RLFX:EmitVehicleExplosion(pos, normal, ent)

Creates large explosion visual effect on entity destruction.

- `pos` — impact position  
- `normal` — surface normal  
- `ent` *(optional)* — destroyed entity (used for smoke parenting)

Includes:
- Fire flash  
- Smoke stack  
- Dust shockwave  

---

### RLFX:EmitHERound(pos, normal)

Creates small fire+dust visual from HE shell explosion.

- `pos` — impact position  
- `normal` — impact normal

Includes:
- Fire core  
- Outgoing sparks  
- Downward dust spray

---

### RLFX:EmitHEATRound(pos, normal)

Creates thin directional sparks for HEAT jets.

- `pos` — impact position  
- `normal` — impact normal

Includes:
- Firelet-like trails  
- Circular explosion effect

---

### RLFX:EmitShot(pos, normal, startSize, ent, doDust)

Main muzzle flash and smoke spawner.

- `pos` — barrel position  
- `normal` — direction  
- `startSize` — scale (number)  
- `ent` — vehicle or gun entity (for dust origin)  
- `doDust` *(bool)* — adds ground dust if true

Includes:
- Two-stage fire flash  
- Smoke trails  
- Shockwave dust if `doDust` is enabled
