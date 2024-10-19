/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


cause = noone
radius = 128
player_shakeness = 30
max_damage = 100


function init() {
	
		with obj_character {
			
			if other.cause != noone && other.cause.team == team {
				continue
			}
			
			var _distance = point_distance(x,y, other.x, other.y)
			
			if _distance <= other.radius * .25 {
				apply_damage(other.max_damage)
			} else if _distance > other.radius * .25 && _distance <= other.radius {
				apply_damage(other.max_damage * _distance / other.radius, )
			}
			
		}
}
