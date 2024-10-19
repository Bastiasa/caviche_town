/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


cause = noone
radius = 128
player_shakeness = 30
max_damage = 100

max_damage_range = 0.5

events = {
	on_character_hitted: new Event()
}

function init() {
	
	if global.particle_manager != noone {
		global.particle_manager.create_particle(
			spr_dust_1,
			{
				position: new Vector(x,y),
				
				max_lifetime:2,
				min_lifetime:2,
				
				max_scale: radius/64,
				min_scale: radius/64,
				
				animation_params: {
					fade_out:0.5
				}
			}
		)
	}
	
		with obj_character {
			
			if other.cause != noone && other.cause.team == team {
				continue
			}
			
			if died {
				continue
			}
			
			var _distance = point_distance(x,y, other.x, other.y)
			var _distance_damage = other.max_damage * _distance / other.radius
			
			if _distance <= other.radius * other.max_damage_range {
				apply_damage(other.max_damage, other.cause)
				other.events.on_character_hitted.fire([self, other.max_damage])
			} else if _distance > other.radius * other.max_damage_range && _distance <= other.radius {
				apply_damage(_distance_damage, other.cause)
				other.events.on_character_hitted.fire([self, _distance_damage])
			}
			
		}
}
