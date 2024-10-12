/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if collision_square == noone {

	collision_square = instance_create_depth(x,_y,depth-1,obj_collision_placeholder)
	collision_square.image_xscale = get_render_width()
	collision_square.image_yscale = get_render_height()
	collision_square.image_angle = rotation
}

global.ui_mouse_click_collision_list = noone