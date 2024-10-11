/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if focused {
	text = keyboard_string
}


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

var _has_text = string_length(text) > 0
var _text_to_draw = _has_text ? text : placeholder
var _text_color = _has_text ? text_color : placeholder_color

draw_set_font(font)
	
draw_set_halign(fa_left)
draw_set_valign(fa_top)
	
draw_text_color(
		
	_x + padding_x,
	_y + padding_y,
		
	_text_to_draw,
		
	_text_color,
	_text_color,
	_text_color,
	_text_color,
		
	1
)

if object_get_parent(object_index) == obj_rectangle {
	reset_surface()
}