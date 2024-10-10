/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _x = x - width * offset_x
var _y = y - height * offset_y

var _rectangle_color = focused ? focused_outline_color : outline_color

draw_rectangle_color(
	_x,
	_y,
	
	_x+width,
	_y+height,
	
	_rectangle_color,
	_rectangle_color,
	_rectangle_color,
	_rectangle_color,
	
	true
)

draw_set_font(font)
	
draw_set_halign(fa_left)
draw_set_valign(fa_top)
	
draw_text_color(
		
	_x + padding_x,
	_y + padding_y,
		
	text,
		
	text_color,
	text_color,
	text_color,
	text_color,
		
	1
)
