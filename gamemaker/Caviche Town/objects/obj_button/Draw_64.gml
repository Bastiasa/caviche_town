/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

var _x = x
var _y = y

var _width = get_render_width()
var _height = get_render_height()

if outline {
	var _rectangle_color_outline = focused ? focused_outline_color : outline_color

	draw_roundrect_color(
		_x,
		_y,
	
		_x+_width,
		_y+_height,
	
		_rectangle_color_outline,
		_rectangle_color_outline,
	
		true
	)
}

if background {
	
	var _rectangle_color = focused ? focused_bg_color : bg_color
	
	draw_roundrect_color(
		_x,
		_y,
	
		_x+_width,
		_y+_height,
	
		_rectangle_color,
		_rectangle_color,
	
		false
	)
}

draw_set_font(font)
	
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

var _text_color = focused ? focused_text_color : text_color

draw_text_color(
		
	_x + _width *.5,
	_y + _height * .5,
		
	text,
		
	_text_color,
	_text_color,
	_text_color,
	_text_color,
		
	1
)

