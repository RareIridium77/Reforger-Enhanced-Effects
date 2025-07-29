```
⚠️ This project is currently a Work In Progress (WIP).
It's in an experimental phase, so breaking changes may happen. Documentation is still being worked on.
```

# Welcome to Reforger-Enhanced-Effects (LVS)

Reforger-Enhanced-Effects is an extension for LVS (Lua Vehicle System) based on [Reforger-Base](https://github.com/RareIridium77/Reforger-Base) that brings your battlefield to life with:
- Improved visual effects (VFX)
- Realistic distant sound effects (SFX)

## Documentation
- [RLFX Cache System](./lua/reforger/shared/Readme.md)
- [RLFX VFX Methods](./lua/reforger/server/vfx.md)
- [RLFX SFX Methods](./lua/reforger/server/sfx.md)
- [RLFX Utils](./lua/reforger/server/utils.md)


## Tools
### convert_wav.py

Requires FFMPEG installed and added to system PATH.  
Download: https://ffmpeg.org/download.html  
Windows builds: https://www.gyan.dev/ffmpeg/builds/

Converts `.wav` files to GMod-supported format:
- Sample Rate: 22050 Hz (balanced quality and optimization)
- Mono
- Format: signed 16-bit PCM

#### Usage:  
```python convert_wav.py [--clean]```

`--clean` - cleans `builded_sounds/` folder before start

**Scans input folders:**
- `sound/rcsm`
- `sound/warthunder`

**Outputs to:**
- `builded_sounds/`

### update_precache_list.py

Generates `init_rlfx_sounds.lua` for automatically caching sounds in-game.

**Expected structure:**  
`sound/rcsm/<ammo>/<distance>/file.wav`  
`sound/warthunder/<ammo>/<distance>/file.wav`


**Result:**
```lua
AddCSLuaFile()
-- Automatically generated code
-- Please don't change anything here. Instead use RLFX Dev tools in reforger/shared/sh_reforger_rlfx_cacher.lua

RLFX = RLFX or {}
RLFX.CachedSounds = {
	["25mm"] = {
		["far"] = {
			["paths"] = { "rcsm/25mm/far/01.wav", "rcsm/25mm/far/02.wav", "rcsm/25mm/far/03.wav", "rcsm/25mm/far/04.wav", "rcsm/25mm/far/05.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/25mm/mid/01.wav", "rcsm/25mm/mid/02.wav", "rcsm/25mm/mid/03.wav", "rcsm/25mm/mid/04.wav", "rcsm/25mm/mid/05.wav" },
		},
	},
    ...
}
```

#### Usage  
Just run it with your python:  
`python update_precache_list.py`
