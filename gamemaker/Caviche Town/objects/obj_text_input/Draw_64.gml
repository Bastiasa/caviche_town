/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _render_width = get_render_width()
var _render_height = get_render_height()

if text_surface == noone || !surface_exists(text_surface) {
	text_surface = create_surface()
}

set_surface(text_surface)

draw_clear_alpha(c_white, 0)
draw_set_font(font)

draw_set_color(_text_color)
draw_set_halign(fa_left)
draw_set_valign(fa_middle)

var _text_width = string_width(typed_text)
var _text_height = string_height("@")

var _text_x = text_offset_x
var _text_y = _render_height * .5 + offset_x

draw_text(
	_text_x,
	_text_y,
	text
)

if focused {
	draw_set_color(cursor_color)
	draw_set_alpha(cursor_alpha)
	
	var _cursor_string_left = get_cursor_left_string_width()
	var _cursor_x = _text_x + string_width(_cursor_string_left)
	
	draw_rectangle(
		_cursor_x,
		_text_y - _text_height * .5,
		_cursor_x + cursor_thickness,
		_text_y + _text_height * .5,
		false
	)
}



surface_reset_target()

draw_set_color(_bg_color)
draw_set_alpha(bg_alpha)

draw_roundrect(x,y, x+_render_width, y+_render_height, false)

draw_set_color(c_white)
draw_set_alpha(1)
draw_surface_part(text_surface, 0, 0, _render_width - padding_x, _render_height - padding_y, x + padding_x * .5, y + padding_y * .5)


draw_set_alpha(1)
draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)


/*if focused {
	
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
}*/

