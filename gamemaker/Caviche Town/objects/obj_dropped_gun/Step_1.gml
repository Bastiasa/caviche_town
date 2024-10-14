/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _delta = delta_time / MILLION

timer += _delta

if gun_information != noone {
	collision_circle_radius = sprite_get_height(gun_information.sprite)
}

var _closer_character = noone
var _collision_circle_result = noone


with obj_character {
	var _distance = point_distance(x,y, other.x, other.y)
	
	show_debug_message(_distance)
	
	if _distance <= other.collision_circle_radius {
		_collision_circle_result = self
		
		
	}
}
 


if _collision_circle_result != noone {
	on_touched_by_character(_collision_circle_result)
}