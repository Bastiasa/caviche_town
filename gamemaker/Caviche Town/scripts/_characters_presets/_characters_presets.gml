// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información

global.characters_sprite_set = {
	default_man: function() {
		return {
			idle: spr_idle_player,
			running: spr_running_player,
			falling: spr_falling_player,
			landing: spr_landing_player,
			wallslide: spr_wallslide_player,
			dash: spr_dashing_player,
			jump: spr_jumping_player,
			death: spr_death_player
		}
	},
	
	default_enemy: function() {
		return {
			idle: spr_idle_enemy,
			running: spr_running_enemy,
			falling: spr_falling_enemy,
			landing: spr_landing_enemy,
			wallslide: spr_wallslide_enemy,
			dash: spr_dashing_enemy,
			jump: spr_jumping_enemy,
			death: spr_death_enemy
		}
	},
	
	hitman: function() {
		return {
			idle: spr_char_hitman_idle,
			running: spr_char_hitman_walk,
			falling: spr_char_hitman_falling,
			landing: spr_char_hitman_landing,
			wallslide: spr_char_hitman_wallslide,
			dash: spr_char_hitman_dash,
			jump: spr_char_hitman_jumping,
			death: spr_char_hitman_death
		}
	},
	
	soldier01: function() {
		return {
			idle: spr_char_soldier01_idle,
			running: spr_char_soldier01_walk,
			falling: spr_char_soldier01_falling,
			wallslide: spr_char_soldier01_wallslide,
			landing: spr_char_soldier01_landing,
			dash: spr_char_soldier01_dash,
			jump: spr_char_soldier01_jumping,
			death: spr_char_soldier01_death
		}
	},
	
	soldier02: function() {
		return {
			idle: spr_soldier02_idle,
			running: spr_soldier02_walk,
			falling: spr_soldier02_falling,
			wallslide: spr_soldier02_wallslide,
			landing: spr_soldier02_landing,
			dash: spr_soldier02_dash,
			jump: spr_soldier02_jumping,
			death: spr_soldier02_death
		}
	},
	
	
	mrjokes: function() {
		return {
			idle: spr_mrjokes_idle,
			running: spr_mrjokes_walk,
			falling: spr_mrjokes_falling,
			wallslide: spr_mrjokes_wallslide,
			landing: spr_mrjokes_landing,
			dash: spr_mrjokes_dash,
			jump: spr_mrjokes_jumping,
			death: spr_mrjokes_death
		}
	},
	
	business_man: function() {
		return {
			idle: spr_business_man_idle,
			running: spr_business_man_walk,
			falling: spr_business_man_falling,
			wallslide: spr_business_man_wallslide,
			landing: spr_business_man_landing,
			dash: spr_business_man_dash,
			jump: spr_business_man_jumping,
			death: spr_business_man_death
		}
	}
}