/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

if focused {
	
	var _font_size = font_get_size(font)
	var _without_last_char_width = string_width(string_delete(text, cursor, string_length(text) - cursor))
	var _last_char_width = string_width(string_char_at(text, string_length(text)-1))
	
	cursor_timer += delta_time / MILLION
	
	if cursor_timer > 0 && cursor_timer < 0.4 {
		
		draw_sprite_ext(
			spr_whitesquare,
			0,
			last_text_position[0] + padding_x*.5 + (_without_last_char_width + _last_char_width) - cursor_thickness * .5, //x + padding_x*.5 + cursor * _font_size - cursor_thickness * .5,
			last_text_position[1] - _font_size * .5 + padding_y * .5, //y + get_render_height()*.5 - _font_size * .5,
			cursor_thickness,
			_font_size,
			rotation,
			cursor_color,
			cursor_alpha
		)
	} else if cursor_timer > 0.8 {
		cursor_timer = 0
	}

}

if text_surface != noone && surface_exists(text_surface) { 
	draw_surface_ext(
		text_surface,
		x + padding_x * .5,
		y + padding_y * .5,
		scale_x,
		scale_y,
		rotation,
		c_white,
		alpha
	)
}

