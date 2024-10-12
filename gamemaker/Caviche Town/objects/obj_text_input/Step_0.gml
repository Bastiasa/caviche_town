/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()



if focused && keyboard_virtual_status() {
	x = 0
	y = 0
	
	width = room_width
	height = room_height - keyboard_virtual_height()
}

if keyboard_check_pressed(vk_anykey) {
	if keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(vk_left){
		cursor -= 1
	} else if text != keyboard_string || keyboard_check_pressed(vk_right) {
		cursor += 1
	}
	
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