/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


if global.ui_mouse_click_collision_list == noone {
	global.ui_mouse_click_collision_list = ds_list_create()

	collision_point_list(
		mouse_x,
		mouse_y,
		all,
		true,
		false,
		global.ui_mouse_click_collision_list,
		true
	)
}

var _target = global.ui_mouse_click_collision_list[|0]

show_debug_message("Mouse click target: ", _target)

if _target != self && collision_square != noone {
	instance_destroy(collision_square.id)
	collision_square = noone
}