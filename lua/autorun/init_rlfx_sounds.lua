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
		["dist_obstructed"] = {
			["paths"] = { "rcsm/25mm/dist_obstructed/01.wav", "rcsm/25mm/dist_obstructed/02.wav", "rcsm/25mm/dist_obstructed/03.wav", "rcsm/25mm/dist_obstructed/04.wav", "rcsm/25mm/dist_obstructed/05.wav" },
		},
		["far"] = {
			["paths"] = { "rcsm/25mm/far/01.wav", "rcsm/25mm/far/02.wav", "rcsm/25mm/far/03.wav", "rcsm/25mm/far/04.wav", "rcsm/25mm/far/05.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/25mm/mid/01.wav", "rcsm/25mm/mid/02.wav", "rcsm/25mm/mid/03.wav", "rcsm/25mm/mid/04.wav", "rcsm/25mm/mid/05.wav" },
		},
	},
	["exp_large"] = {
		["close"] = {
			["paths"] = { "rcsm/exp_large/close/01.wav", "rcsm/exp_large/close/02.wav", "rcsm/exp_large/close/03.wav", "rcsm/exp_large/close/04.wav", "rcsm/exp_large/close/05.wav" },
		},
		["dist"] = {
			["paths"] = { "rcsm/exp_large/dist/01.wav", "rcsm/exp_large/dist/02.wav", "rcsm/exp_large/dist/03.wav", "rcsm/exp_large/dist/04.wav", "rcsm/exp_large/dist/05.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "rcsm/exp_large/dist_obstructed/01.wav", "rcsm/exp_large/dist_obstructed/02.wav", "rcsm/exp_large/dist_obstructed/03.wav", "rcsm/exp_large/dist_obstructed/04.wav", "rcsm/exp_large/dist_obstructed/05.wav" },
		},
		["far"] = {
			["paths"] = { "rcsm/exp_large/far/01.wav", "rcsm/exp_large/far/02.wav", "rcsm/exp_large/far/03.wav", "rcsm/exp_large/far/04.wav", "rcsm/exp_large/far/05.wav" },
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
		["far"] = {
			["paths"] = { "rcsm/exp_mid/far/01.wav", "rcsm/exp_mid/far/02.wav", "rcsm/exp_mid/far/03.wav", "rcsm/exp_mid/far/04.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/exp_mid/mid/01.wav", "rcsm/exp_mid/mid/02.wav", "rcsm/exp_mid/mid/03.wav", "rcsm/exp_mid/mid/04.wav" },
		},
	},
	["other"] = {
		["close"] = {
			["paths"] = { "rcsm/other/close/1.wav", "rcsm/other/close/10.wav", "rcsm/other/close/2.wav", "rcsm/other/close/3.wav", "rcsm/other/close/4.wav", "rcsm/other/close/5.wav", "rcsm/other/close/6.wav", "rcsm/other/close/7.wav", "rcsm/other/close/8.wav", "rcsm/other/close/9.wav" },
		},
		["dist"] = {
			["paths"] = { "rcsm/other/dist/1.wav", "rcsm/other/dist/10.wav", "rcsm/other/dist/2.wav", "rcsm/other/dist/3.wav", "rcsm/other/dist/4.wav", "rcsm/other/dist/5.wav", "rcsm/other/dist/6.wav", "rcsm/other/dist/7.wav", "rcsm/other/dist/8.wav", "rcsm/other/dist/9.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "rcsm/other/dist_obstructed/1.wav", "rcsm/other/dist_obstructed/10.wav", "rcsm/other/dist_obstructed/2.wav", "rcsm/other/dist_obstructed/3.wav", "rcsm/other/dist_obstructed/4.wav", "rcsm/other/dist_obstructed/5.wav", "rcsm/other/dist_obstructed/6.wav", "rcsm/other/dist_obstructed/7.wav", "rcsm/other/dist_obstructed/8.wav", "rcsm/other/dist_obstructed/9.wav" },
		},
		["far"] = {
			["paths"] = { "rcsm/other/far/1.wav", "rcsm/other/far/10.wav", "rcsm/other/far/2.wav", "rcsm/other/far/3.wav", "rcsm/other/far/4.wav", "rcsm/other/far/5.wav", "rcsm/other/far/6.wav", "rcsm/other/far/7.wav", "rcsm/other/far/8.wav", "rcsm/other/far/9.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "rcsm/other/far_obstructed/1.wav", "rcsm/other/far_obstructed/2.wav", "rcsm/other/far_obstructed/3.wav", "rcsm/other/far_obstructed/4.wav" },
		},
		["mid"] = {
			["paths"] = { "rcsm/other/mid/1.wav", "rcsm/other/mid/10.wav", "rcsm/other/mid/2.wav", "rcsm/other/mid/3.wav", "rcsm/other/mid/4.wav", "rcsm/other/mid/5.wav", "rcsm/other/mid/6.wav", "rcsm/other/mid/7.wav", "rcsm/other/mid/8.wav", "rcsm/other/mid/9.wav" },
		},
	},
	["exp_bomb"] = {
		["close"] = {
			["paths"] = { "warthunder/exp_bomb/close/01.wav", "warthunder/exp_bomb/close/02.wav", "warthunder/exp_bomb/close/03.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/exp_bomb/dist/01.wav", "warthunder/exp_bomb/dist/02.wav", "warthunder/exp_bomb/dist/03.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "warthunder/exp_bomb/dist_obstructed/01.wav", "warthunder/exp_bomb/dist_obstructed/02.wav", "warthunder/exp_bomb/dist_obstructed/03.wav" },
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
		["dist"] = {
			["paths"] = { "warthunder/start_missile/dist/01.wav", "warthunder/start_missile/dist/02.wav", "warthunder/start_missile/dist/03.wav" },
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
			["paths"] = { "warthunder/tank_explosion/close/01.wav", "warthunder/tank_explosion/close/02.wav", "warthunder/tank_explosion/close/03.wav", "warthunder/tank_explosion/close/04.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/tank_explosion/dist/01.wav", "warthunder/tank_explosion/dist/02.wav", "warthunder/tank_explosion/dist/03.wav", "warthunder/tank_explosion/dist/04.wav" },
		},
		["far"] = {
			["paths"] = { "warthunder/tank_explosion/far/01.wav", "warthunder/tank_explosion/far/02.wav", "warthunder/tank_explosion/far/03.wav", "warthunder/tank_explosion/far/04.wav" },
		},
		["far_obstructed"] = {
			["paths"] = { "warthunder/tank_explosion/far_obstructed/01.wav", "warthunder/tank_explosion/far_obstructed/02.wav", "warthunder/tank_explosion/far_obstructed/03.wav", "warthunder/tank_explosion/far_obstructed/04.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/tank_explosion/mid/01.wav", "warthunder/tank_explosion/mid/02.wav", "warthunder/tank_explosion/mid/03.wav", "warthunder/tank_explosion/mid/04.wav" },
		},
	},
	["tank_fire"] = {
		["close"] = {
			["paths"] = { "warthunder/tank_fire/close/01.wav", "warthunder/tank_fire/close/02.wav", "warthunder/tank_fire/close/03.wav" },
		},
		["dist"] = {
			["paths"] = { "warthunder/tank_fire/dist/01.wav", "warthunder/tank_fire/dist/02.wav", "warthunder/tank_fire/dist/03.wav" },
		},
		["dist_obstructed"] = {
			["paths"] = { "warthunder/tank_fire/dist_obstructed/01.wav", "warthunder/tank_fire/dist_obstructed/02.wav", "warthunder/tank_fire/dist_obstructed/03.wav" },
		},
		["far"] = {
			["paths"] = { "warthunder/tank_fire/far/01.wav", "warthunder/tank_fire/far/02.wav", "warthunder/tank_fire/far/03.wav" },
		},
		["mid"] = {
			["paths"] = { "warthunder/tank_fire/mid/01.wav", "warthunder/tank_fire/mid/02.wav", "warthunder/tank_fire/mid/03.wav" },
		},
	},
}
