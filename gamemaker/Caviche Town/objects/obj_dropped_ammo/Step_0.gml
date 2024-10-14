/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

collision_circle_radius = sprite_get_height(sprite_index)

var _collision_circle_result = noone


with obj_character {
	var _sprite_size = get_sprite_size().multiply(.5)
	var _distance = point_distance(x,y, other.x, other.y)
	var _sprite_length = point_distance(0,0, _sprite_size.x, _sprite_size.y)
	
	if _distance <= other.collision_circle_radius + _sprite_length {
		_collision_circle_result = self
	}
}

if _collision_circle_result != noone {
	on_touched_by_character(_collision_circle_result)
}
