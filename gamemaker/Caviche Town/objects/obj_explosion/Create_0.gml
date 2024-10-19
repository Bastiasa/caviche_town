/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


cause = noone
radius = 128
player_shakeness = 30

max_force = 30

max_damage = 100
max_damage_range = 0.5

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
	
	if global.particle_manager != noone {
		global.particle_manager.create_particle(
			spr_dust_1,
			{
				position: new Vector(x,y),
				
				max_lifetime:2,
				min_lifetime:2,
				
				max_scale: radius/32,
				min_scale: radius/32,
				
				animation_params: {
					fade_out:0.5
				}
			}
		)
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
				controller.camera_shakeness += (other.player_shakeness*(1 - _distance/other.radius)) + 25 
				show_debug_message("Shakeness")
			}
			
			if _distance <= other.radius * other.max_damage_range {
				other.character_gotten_by_explosion(self, other.max_damage)
			} else if _distance > other.radius * other.max_damage_range && _distance <= other.radius {
				other.character_gotten_by_explosion(self, _distance_damage)
			}
			
		}
}
