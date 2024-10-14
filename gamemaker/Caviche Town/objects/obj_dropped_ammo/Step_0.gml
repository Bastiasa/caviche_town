/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

collision_circle_radius = sprite_get_height(sprite_index)

var _collision_circle_result = collision_circle(x,y, collision_circle_radius, obj_character, false, true)

if _collision_circle_result != noone {
	on_character_touched(_collision_circle_result)
}

