/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

timer += delta_time / MILLION


var _last_text = string_copy(text, 0, string_length(text))
text = string_insert(keyboard_string, text, cursor)
var _difference = string_length(text) - string_length(_last_text)

if _difference != 0 {
	
}


if focused {
	text = keyboard_string
}

cursor = clamp(cursor, 0, string_length(text) + 1)

if string_length(keyboard_string) <= 0 {
	text = placeholder
	text_color = placeholder_color
} else {
	text_color = _normal_text_color
}


if surface != noone && surface_exists(surface) {
	surface_resize(
		surface,
		max(1, get_render_width() - padding_x),
		max(1, get_render_height())
	)
}