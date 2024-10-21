/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


if global.debugging	{
	var _corners = corners()
	
	array_push(_corners, get_offset_position(0, .5), get_offset_position(1,.5), get_offset_position(.5, 0), get_offset_position(.5, 1))

	draw_set_color(c_purple)
	draw_set_alpha(.65)
	
	array_foreach(_corners, function(_corner) {
		draw_circle(_corner[0], _corner[1], 4, false)
	})
	
	draw_set_color(c_blue)
	draw_circle(position_x, position_y, 4, false)
	
	draw_set_color(c_red)

	draw_line(x, 0, x, y)
	draw_line(0,y, x, y)

	draw_set_color(c_white)
	draw_set_alpha(1)
	
	
}
