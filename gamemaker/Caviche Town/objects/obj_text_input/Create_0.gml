/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

max_length = -1
text = ""

text_color = c_black
placeholder_color = c_gray

_text_color = text_color

bg_color = make_color_rgb(255,255,255)
focused_bg_color = make_color_rgb(240,240,255)

_bg_color = bg_color

bg_alpha = 1

dragging = false

typed_text = ""
placeholder = ""

modal = true

padding_x = 40
padding_y = 0

text_offset_x = 0
text_offset_y = 0

cursor_thickness = 2
cursor_color = c_black
cursor_alpha = 0.9
cursor_position = 0

selecting = false
select_begin = -1
select_end = -1

command_keys = [vk_left, vk_right, vk_backspace, vk_end, vk_home]

font = fnt_current_gun_ammo

text_surface = create_surface()

virtual_keyboard = {
	type: kbv_type_ascii,
	return_type: kbv_returnkey_emergency,
	autocapitalize: kbv_autocapitalize_none,
	predictivie_text_enabled: true
}

cooldown = 0.5


allowed_characters = ASCII_CHARS

events.on_mouse_click.add_listener(function() {
	if focused {
		keyboard_virtual_show(virtual_keyboard.type, virtual_keyboard.return_type, virtual_keyboard.autocapitalize, virtual_keyboard.predictivie_text_enabled)
	}
	
	keyboard_string = ""
	cursor_position = get_cursor_position_from_position()
})

events.on_blur.add_listener(function() {
	keyboard_virtual_hide()
})

function get_allowed_chars(_str) {
	var _result = ""
	
	for(var _index = 1; _index < string_length(_str) + 1; _index++) {
		var _char = string_char_at(_str, _index)
		
		if string_pos(_char, allowed_characters) != 0 {
			_result += _char
		}
	}
	
	return _result
}

function get_cursor_position_from_position(_x = mouse_x) {
	var _local_right = _x - x - padding_x - text_offset_x
	return string_char_pos_on_width(typed_text, abs(_local_right))
}

function get_cursor_left_string_width() {
	return string_copy(typed_text, 0, cursor_position)
}