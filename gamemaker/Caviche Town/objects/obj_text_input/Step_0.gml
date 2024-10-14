/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()


if keyboard_check_pressed(vk_backspace) {
	cursor -= 2
	text = string_delete(text, cursor + 1, 2)
}

if keyboard_lastkey == vk_backspace {
	keyboard_lastkey = vk_nokey
	keyboard_lastchar = ""
}

if focused && keyboard_lastkey != vk_nokey {
	
	var _last_text = string_copy(text, 0, string_length(text))
	text = string_insert(keyboard_lastchar, text, cursor + 1)
	var _difference = string_length(text) - string_length(_last_text)
	
	cursor += _difference
	
	show_debug_message("Last char: "+keyboard_lastchar)
	show_debug_message("Last key: "+string(keyboard_lastkey))
	
	if _difference != 0 {
		keyboard_lastkey = vk_nokey
		keyboard_lastchar = ""
		
	}
	
}






if surface != noone && surface_exists(surface) {
	surface_resize(
		surface,
		max(1, get_render_width() - padding_x),
		max(1, get_render_height())
	)
}