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
	
	var _center_position = [other.x, other.y]
	
	var _sprite_size = get_sprite_size().multiply(.5)
	var _distance = point_distance(_center_position[0],_center_position[1], x, y)
	var _sprite_length = point_distance(0,0, _sprite_size.x, _sprite_size.y)
	
	if _distance <= other.collision_circle_radius* other.gun_information.scale + _sprite_length {
		_collision_circle_result = self
	}
}
 


if _collision_circle_result != noone {
	on_touched_by_character(_collision_circle_result)
}