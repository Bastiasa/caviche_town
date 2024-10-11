/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

return

if focused && (timer <= 0 || timer >= cooldown) {
	
	if keyboard_lastkey == vk_backspace {
		text = string_delete(text, cursor, 1)
		cursor -= 1
	} else if keyboard_key == vk_left {
		cursor -= 1
	} else if keyboard_key == vk_right {
		cursor += 1
	} else if string_byte_at(keyboard_lastchar, 0) != 8 {
		text = string_insert(keyboard_lastchar, text, cursor+1)
		cursor += 1
	}
	
	
	cursor = clamp(cursor, 0, string_length(text))
	
}

timer += delta_time/MILLION