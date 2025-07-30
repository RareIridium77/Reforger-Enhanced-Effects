AddCSLuaFile()
-- Automatically generated code
-- Please don't change anything here. Instead use RLFX Dev tools in reforger/shared/sh_reforger_rlfx_cacher.lua

RLFX = RLFX or {}
RLFX.CachedSounds = {
	["25mm"] = {
		["close"] = {
			["paths"] = { "rcsm/25mm/close/01.wav", "rcsm/25mm/close/02.wav", "rcsm/25mm/close/03.wav", "rcsm/25mm/close/04.wav", "rcsm/25mm/close/05.wav" },
		},
		["dist"] = {
			["paths"] = { "rcsm/25mm/dist/01.wav", "rcsm/25mm/dist/02.wav", "rcsm/25mm/dist/03.wav", "rcsm/25mm/dist/04.wav", "rcsm/25mm/dist/05.wav" },
		},
		["far"] = {
			["paths"] = { "rcsm/25mm/far/01.wav", "rcsm/25mm/far/02.wav", "rcsm/25mm/far/03.wav", "rcsm/25mm/far/04.wav", "rcsm/25mm/far/05.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "rcsm/25mm/far_obstructed/01.wav", "rcsm/25mm/far_obstructed/02.wav", "rcsm/25mm/far_obstructed/03.wav", "rcsm/25mm/far_obstructed/04.wav", "rcsm/25mm/far_obstructed/05.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/25mm/mid/01.wav", "rcsm/25mm/mid/02.wav", "rcsm/25mm/mid/03.wav", "rcsm/25mm/mid/04.wav", "rcsm/25mm/mid/05.wav" },
		},
		["mid_obstructed"] = {
			["paths"] = { "rcsm/25mm/mid_obstructed/01.wav", "rcsm/25mm/mid_obstructed/02.wav", "rcsm/25mm/mid_obstructed/03.wav", "rcsm/25mm/mid_obstructed/04.wav", "rcsm/25mm/mid_obstructed/05.wav" },
		},
	},
	["exp_large"] = {
		["close"] = {
			["paths"] = { "rcsm/exp_large/close/01.wav", "rcsm/exp_large/close/02.wav", "rcsm/exp_large/close/03.wav", "rcsm/exp_large/close/04.wav", "rcsm/exp_large/close/05.wav" },
		},
		["dist"] = {
			["paths"] = { "rcsm/exp_large/dist/01.wav", "rcsm/exp_large/dist/02.wav", "rcsm/exp_large/dist/03.wav", "rcsm/exp_large/dist/04.wav", "rcsm/exp_large/dist/05.wav" },
		},
		["far"] = {
			["paths"] = { "rcsm/exp_large/far/01.wav", "rcsm/exp_large/far/02.wav", "rcsm/exp_large/far/03.wav", "rcsm/exp_large/far/04.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "rcsm/exp_large/far_obstructed/01.wav", "rcsm/exp_large/far_obstructed/02.wav", "rcsm/exp_large/far_obstructed/03.wav", "rcsm/exp_large/far_obstructed/04.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/exp_large/mid/01.wav", "rcsm/exp_large/mid/02.wav", "rcsm/exp_large/mid/03.wav", "rcsm/exp_large/mid/04.wav", "rcsm/exp_large/mid/05.wav" },
		},
	},
	["exp_mid"] = {
		["close"] = {
			["paths"] = { "rcsm/exp_mid/close/01.wav", "rcsm/exp_mid/close/02.wav", "rcsm/exp_mid/close/03.wav", "rcsm/exp_mid/close/04.wav" },
		},
		["dist"] = {
			["paths"] = { "rcsm/exp_mid/dist/01.wav", "rcsm/exp_mid/dist/02.wav", "rcsm/exp_mid/dist/03.wav", "rcsm/exp_mid/dist/04.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "rcsm/exp_mid/dist_obstructed/01.wav", "rcsm/exp_mid/dist_obstructed/02.wav", "rcsm/exp_mid/dist_obstructed/03.wav", "rcsm/exp_mid/dist_obstructed/04.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/exp_mid/mid/01.wav", "rcsm/exp_mid/mid/02.wav", "rcsm/exp_mid/mid/03.wav", "rcsm/exp_mid/mid/04.wav" },
		},
	},
	["other"] = {
		["dist"] = {
			["paths"] = { "rcsm/other/dist/01.wav", "rcsm/other/dist/02.wav", "rcsm/other/dist/03.wav", "rcsm/other/dist/04.wav", "rcsm/other/dist/05.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "rcsm/other/dist_obstructed/01.wav", "rcsm/other/dist_obstructed/02.wav", "rcsm/other/dist_obstructed/03.wav", "rcsm/other/dist_obstructed/04.wav", "rcsm/other/dist_obstructed/05.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/other/mid/01.wav", "rcsm/other/mid/02.wav", "rcsm/other/mid/03.wav", "rcsm/other/mid/04.wav", "rcsm/other/mid/05.wav" },
		},
	},
	["exp_bomb"] = {
		["close"] = {
			["paths"] = { "warthunder/exp_bomb/close/01.wav", "warthunder/exp_bomb/close/02.wav", "warthunder/exp_bomb/close/03.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/exp_bomb/dist/01.wav", "warthunder/exp_bomb/dist/02.wav", "warthunder/exp_bomb/dist/03.wav" },
		},
		["far"] = {
			["paths"] = { "warthunder/exp_bomb/far/01.wav", "warthunder/exp_bomb/far/02.wav", "warthunder/exp_bomb/far/03.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "warthunder/exp_bomb/far_obstructed/01.wav", "warthunder/exp_bomb/far_obstructed/02.wav", "warthunder/exp_bomb/far_obstructed/03.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/exp_bomb/mid/01.wav", "warthunder/exp_bomb/mid/02.wav", "warthunder/exp_bomb/mid/03.wav" },
		},
	},
	["start_missile"] = {
		["close"] = {
			["paths"] = { "warthunder/start_missile/close/01.wav", "warthunder/start_missile/close/02.wav", "warthunder/start_missile/close/03.wav" },
		},
		["far"] = {
			["paths"] = { "warthunder/start_missile/far/01.wav", "warthunder/start_missile/far/02.wav", "warthunder/start_missile/far/03.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "warthunder/start_missile/far_obstructed/01.wav", "warthunder/start_missile/far_obstructed/02.wav", "warthunder/start_missile/far_obstructed/03.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/start_missile/mid/01.wav", "warthunder/start_missile/mid/02.wav", "warthunder/start_missile/mid/03.wav" },
		},
		["mid_obstructed"] = {
			["paths"] = { "warthunder/start_missile/mid_obstructed/01.wav", "warthunder/start_missile/mid_obstructed/02.wav", "warthunder/start_missile/mid_obstructed/03.wav" },
		},
	},
	["tank_explosion"] = {
		["close"] = {
			["paths"] = { "warthunder/tank_explosion/close/tank_explosion_far_01.wav", "warthunder/tank_explosion/close/tank_explosion_far_02.wav", "warthunder/tank_explosion/close/tank_explosion_far_03.wav", "warthunder/tank_explosion/close/tank_explosion_far_04.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/tank_explosion/dist/tank_explosion_far_01.wav", "warthunder/tank_explosion/dist/tank_explosion_far_02.wav", "warthunder/tank_explosion/dist/tank_explosion_far_03.wav", "warthunder/tank_explosion/dist/tank_explosion_far_04.wav" },
		},
		["far"] = {
			["paths"] = { "warthunder/tank_explosion/far/tank_explosion_far_01.wav", "warthunder/tank_explosion/far/tank_explosion_far_02.wav", "warthunder/tank_explosion/far/tank_explosion_far_03.wav", "warthunder/tank_explosion/far/tank_explosion_far_04.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "warthunder/tank_explosion/far_obstructed/tank_explosion_far_01.wav", "warthunder/tank_explosion/far_obstructed/tank_explosion_far_02.wav", "warthunder/tank_explosion/far_obstructed/tank_explosion_far_03.wav", "warthunder/tank_explosion/far_obstructed/tank_explosion_far_04.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/tank_explosion/mid/tank_explosion_far_01.wav", "warthunder/tank_explosion/mid/tank_explosion_far_02.wav", "warthunder/tank_explosion/mid/tank_explosion_far_03.wav", "warthunder/tank_explosion/mid/tank_explosion_far_04.wav" },
		},
	},
	["tank_fire"] = {
		["close"] = {
			["paths"] = { "warthunder/tank_fire/close/tank_fire_1.wav", "warthunder/tank_fire/close/tank_fire_2.wav", "warthunder/tank_fire/close/tank_fire_3.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/tank_fire/dist/tank_fire_1.wav", "warthunder/tank_fire/dist/tank_fire_2.wav", "warthunder/tank_fire/dist/tank_fire_3.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "warthunder/tank_fire/dist_obstructed/tank_fire_1.wav", "warthunder/tank_fire/dist_obstructed/tank_fire_2.wav", "warthunder/tank_fire/dist_obstructed/tank_fire_3.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/tank_fire/mid/tank_fire_1.wav", "warthunder/tank_fire/mid/tank_fire_2.wav", "warthunder/tank_fire/mid/tank_fire_3.wav" },
		},
	},
}
