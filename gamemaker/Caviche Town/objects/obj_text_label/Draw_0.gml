/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();
set_surface(surface)

if string_length(text) > 0 {
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
		_relative_y = 0.5// - (font_get_size(font) * scale_y * .5) / height
		break
	
		case fa_bottom:
		_relative_y = 1
		break
	}

	var _text_position = get_offset_position(_relative_x,_relative_y)
	
	if has_parent() {
		_text_position[0] -= parent.x
		_text_position[1] -= parent.y
	}
	
	if has_own_surface() {
		_text_position[0] = _relative_x * get_render_width()
		_text_position[1] = _relative_y * get_render_height()
	}
	
	last_text_position = _text_position
	
	if text_wrapping {
		draw_text_ext_transformed(
			_text_position[0] + text_offset_x,
			_text_position[1] + text_offset_y,
	
			text,
	
			font_get_size(font),
	
			get_render_width(),
			text_scale_x,
			text_scale_y,
	
			rotation
		)
	} else {
		draw_text_transformed(
			_text_position[0],
			_text_position[1],
	
			text,

			text_scale_x,
			text_scale_y,
	
			rotation
		)
	}
	

}

draw_set_color(c_white)
reset_surface()