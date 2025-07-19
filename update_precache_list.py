"""
THIS SCRIPT CREATED init_rlfx_sounds.lua IN LUA autorun FOR AUTOMATICLY CACHING SOUNDS IN GAME.
"""

import os

ROOT_DIRS = ["sound/rcsm", "sound/warthunder"] ## DO NOT CHANGE THIS PARAM IF NOT NEEDED ##
DEFAULT_LUA_PATH = "lua/autorun/init_rlfx_sounds.lua" ## DO NOT CHANGE THIS PARAM ##

def collect_sounds():
    cached_sounds = {}

    for root_dir in ROOT_DIRS:
        for root, _, files in os.walk(root_dir):
            files.sort()
            for file in files:
                if not file.lower().endswith(".wav"):
                    continue

                full_path = os.path.join(root, file)
                relative_path = full_path.replace("sound/", "").replace("\\", "/").lower()
                parts = relative_path.split("/")

                # Expecting: rcsm/<ammo>/<distance>/file.wav or warthunder/<ammo>/<distance>/file.wav
                if len(parts) < 4:
                    continue

                _, ammo_type, distance_type = parts[:3]

                ammo_entry = cached_sounds.setdefault(ammo_type, {})
                distance_entry = ammo_entry.setdefault(distance_type, {
                    "paths": []
                })

                distance_entry["paths"].append(relative_path)

    return cached_sounds

def dump_lua_table(data, indent=0):
    tabs = "\t" * indent
    if isinstance(data, dict):
        lines = ["{"]
        for key, value in data.items():
            lua_key = f'["{key}"]'
            lua_value = dump_lua_table(value, indent + 1)
            lines.append(f'{tabs}\t{lua_key} = {lua_value},')
        lines.append(tabs + "}")
        return "\n".join(lines)
    elif isinstance(data, list):
        items = ", ".join(f'"{v}"' for v in data)
        return f"{{ {items} }}"
    else:
        return f'"{str(data)}"'

def main():
    sounds_data = collect_sounds()
    lua_table = dump_lua_table(sounds_data)

    lua_output = "AddCSLuaFile()\n"
    lua_output += "-- Automatically generated code\n"
    lua_output += "-- Please don't change anything here. Instead use RLFX Dev tools in reforger/shared/sh_reforger_rlfx_cacher.lua\n\n"
    lua_output += "RLFX = RLFX or {}\n"
    lua_output += f"RLFX.CachedSounds = {lua_table}\n"
    
    os.makedirs(os.path.dirname(DEFAULT_LUA_PATH), exist_ok=True)

    with open(DEFAULT_LUA_PATH, "w+", encoding="utf-8") as file:
        file.write(lua_output)

    print(f"Lua precache file generated: {DEFAULT_LUA_PATH}")

if __name__ == "__main__":
    main()
