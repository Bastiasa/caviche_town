/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

explosion_sound = snd_explosion

cause = noone
radius = 128
player_shakeness = 30

max_force = 30

max_damage = 100
max_damage_range = 0.5

sprite_index = -1

events = {
	on_character_hitted: new Event()
}

function character_gotten_by_explosion(_character, _damage) {
	_character.apply_damage(_damage, cause)
	events.on_character_hitted.fire([_character, _damage])
	
	var _dir_x = _character.x - x
	var _dir_y = _character.y - y
	
	var _dir_length = point_distance(_character.x, _character.y, x, y)
	
	var _normal_x = _dir_x / _dir_length
	var _normal_y = _dir_y / _dir_length
	
	var _force = max_force / _dir_length
	
	_character.velocity.x += _force * _normal_x
	_character.velocity.y += _force * _normal_y
}

function init() {
	
	audio_play_sound_at(
	explosion_sound,
	x,
	y,
	0, 
	radius, 
	radius * 3, radius*2, false, 1)
	
	if global.particle_manager != noone {
		global.particle_manager.create_particle(
			spr_radial_explosion,
			{
				position: new Vector(x,y),
				
				max_lifetime:0.5,
				min_lifetime:0.5,
				
				max_scale: radius/sprite_get_width(spr_radial_explosion),
				min_scale: radius/sprite_get_width(spr_radial_explosion),
				
				animation_params: {
					fade_out:.4
				}
			},
			
			noone
		)
	}
	
	with obj_grenade {
	
		var _distance = point_distance(x,y,other.x, other.y)
		
		if _distance <= other.radius {
			explode()
		}
	}
	
	with obj_character {
			
		if other.cause != noone && other.cause.team == team && other.cause != self {
			continue
		}
			
		if current_state == CHARACTER_STATE.DASHING {
			continue
		}
			
		if died {
			continue
		}
			

			
		var _sprite_size = get_sprite_size().abs()
		var _sprite_length = _sprite_size.multiply(.5).magnitude()
		var _distance = point_distance(x,y, other.x, other.y) - _sprite_length
		var _distance_damage = other.max_damage * _distance / other.radius
			
		if is_player(self) {
			controller.camera_shakeness += (other.player_shakeness*(1 - _distance/(other.radius*2))) + 25 
		}
			
		if _distance <= other.radius * other.max_damage_range {
			other.character_gotten_by_explosion(self, other.max_damage)
		} else if _distance > other.radius * other.max_damage_range && _distance <= other.radius {
			other.character_gotten_by_explosion(self, _distance_damage)
		}
			
	}
	
	var _collisions = ds_list_create()
	var _collision_circle_list = collision_circle_list(x,y, radius * 3, obj_dropped_gun, false, true, _collisions, false)
	var _collision_count = ds_list_size(_collisions)
	
	if _collision_count > 0 {
		for(var _index = 0; _index < _collision_count; _index++) {
			var _collision_target = _collisions[|_index]
			
			if _collision_target != undefined && _collision_target != noone {
				with _collision_target {
					var _distance = point_distance(other.x, other.y, x, y)
					
					var _dir_x = x - other.x
					var _dir_y = y - other.y
					
					var _force= _distance / other.radius * other.max_damage
					
					physics_apply_impulse(x,y, _dir_x * _force, _dir_y * _force)
					physics_apply_angular_impulse(_force)
					
					if gun_information.bullet_type == BULLET_TYPE.ROCKET && gun_information.loaded_ammo > 0 {
					
						var _total_explosions = gun_information.loaded_ammo
						gun_information.loaded_ammo = 0
						
						for(var _ammo = 0; _ammo < _total_explosions; _ammo++) {
							create_and_init_explosion(x,y, layer, 64, 100, 0.6, other.cause)
						}
					}
				}
			}
		}
	}
	
	instance_destroy(id)
}
