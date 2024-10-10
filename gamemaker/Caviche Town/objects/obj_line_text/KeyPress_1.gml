/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if focused {
	
	if keyboard_lastkey == vk_backspace {
		text = string_delete(text, cursor, 1)
		cursor -= 1
	} else if keyboard_key == vk_left {
		cursor -= 1
	} else if keyboard_key == vk_right {
		cursor += 1
	} else {
		text = string_insert(keyboard_lastchar, text, cursor+1)
		cursor += 1
	}
	
	cursor = clamp(cursor, 0, string_length(text))
	
}