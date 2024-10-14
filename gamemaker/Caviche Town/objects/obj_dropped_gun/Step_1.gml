/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _delta = delta_time / MILLION

timer += _delta

if gun_information != noone {
	collision_circle_radius = sprite_get_height(gun_information.sprite)
}

var _collision_circle_result = collision_circle(x, y, collision_circle_radius, obj_character, false, true)

if _collision_circle_result != noone {
	on_touched_by_character(_collision_circle_result)
}