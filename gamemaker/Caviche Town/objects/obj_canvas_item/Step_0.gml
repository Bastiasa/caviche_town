/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


mask_index = spr_whitesquare

image_xscale = get_render_width()
image_yscale = get_render_height()
image_angle = rotation


if is_real(relative_position_x) {
	position_x = relative_position_x * display_get_gui_width()
}

if is_real(relative_position_y) {
	position_y = relative_position_y * display_get_gui_height()
}

if rotation == 0 {
	x = position_x - get_render_width() * offset_x
	y = position_y - get_render_height() * offset_y
} else {
	
	var _width_offset = get_render_width() * offset_x
	var _height_offset = get_render_height() * offset_y

	var _x_right_position = lengthdir_x(_width_offset, rotation)
	var _y_right_position = lengthdir_y(_width_offset, rotation)
	
	var _x_top_position = lengthdir_x(_height_offset, rotation-90)
	var _y_top_position = lengthdir_y(_height_offset, rotation-90)
	
	x = position_x - _x_right_position - _x_top_position
	y = position_y - _y_right_position - _y_top_position

}





//is_mouse_inside = (mouse_x > x && mouse_x < x + get_render_width()) && (mouse_y > y && mouse_y < y + get_render_height())