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
			wallslide: spr_char_hitman_wallslide,
			dash: spr_char_hitman_dash,
			jump: spr_char_hitman_jumping,
			
		}
	}
}