/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

draw_set_font(fnt_current_gun_ammo)
draw_set_color(text_color)

draw_set_halign(text_horizontal_align)
draw_set_valign(text_vertical_align)

var _top_left_position = get_offset_position()
var _relative_x = 0
var _relative_y = 0


switch text_horizontal_align {
	case fa_left:
	_relative_x = 0
	break
	
	case fa_center:
	_relative_x = .5
	break
	
	case fa_right:
	_relative_x = 1
	break
}

switch text_vertical_align {
	case fa_top:
	_relative_y = 0
	break
	
	case fa_middle:
	_relative_y = 0.5 - (font_get_size(font) * scale_y * .5) / height
	break
	
	case fa_bottom:
	_relative_y = 1
	break
}

var _text_position = get_offset_position(_relative_x,_relative_y)

draw_text_ext_transformed(
	_text_position[0],
	_text_position[1],
	
	text,
	
	font_get_size(font),
	
	width*scale_x,
	text_scale_x,
	text_scale_y,
	rotation
)


draw_set_color(c_white)