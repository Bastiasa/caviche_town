/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

draw_set_font(fnt_current_gun_ammo)
draw_set_color(text_color)

draw_set_halign(text_horizontal_align)
draw_set_valign(text_vertical_align)

var _text_position_x = x
var _text_position_y = y

switch text_horizontal_align {
	
	case fa_left:
	_text_position_x = get_offset_position()[0]
	break
	
	case fa_center:
	_text_position_x = get_offset_position(.5)[0]
	break
}

switch text_vertical_align {
	case fa_middle:
	_text_position_y = get_offset_position(0,.5)[1]
}

draw_text_ext_transformed(
	_text_position_x,
	_text_position_y,
	
	text,
	
	font_get_size(font),
	
	width*scale_x,
	text_scale_x,
	text_scale_y,
	rotation
)


draw_set_color(c_white)