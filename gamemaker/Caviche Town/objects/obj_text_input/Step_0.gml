/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()


set_surface_size(text_surface)



cursor_position = clamp(cursor_position, 0, string_length(typed_text))

if !dragging {
	var _typed_text_width = string_width(typed_text)
	var _cursor_left_string = get_cursor_left_string_width()
	var _cursor_left_string_width = string_width(_cursor_left_string)
	var _left_limit = string_width(string_char_at(_cursor_left_string, string_length(_cursor_left_string) - 1)) + cursor_thickness
	var _right_limit = get_render_width() - padding_x - cursor_thickness


	if _cursor_left_string_width + text_offset_x  < _left_limit {
		text_offset_x += _left_limit -  (_cursor_left_string_width + text_offset_x)
	} else if _cursor_left_string_width + text_offset_x > _right_limit  {
		text_offset_x += _right_limit - (_cursor_left_string_width + text_offset_x)
	}
}

text_offset_x = clamp(text_offset_x, -string_width(typed_text) + get_render_width() - padding_x, 0)



if focused {
	
	if array_get_index(command_keys, keyboard_lastkey) != -1 {
	
		switch keyboard_lastkey {
			case vk_left:
			cursor_position -= 1
			break
		
			case vk_right:
			cursor_position += 1
			break
		
			case vk_backspace:
			cursor_position -= 1
	
			if cursor_position >= 0 {
				typed_text = string_delete(typed_text, cursor_position + 1, 1)
				input_events.on_text_changed.fire()
			}
			break
		
		
			case vk_home:
			cursor_position = 0
			break
		
			case vk_end:
			cursor_position = string_length(typed_text)
			break
		}
	
		keyboard_lastchar = ""
		keyboard_lastkey = vk_nokey
	}

	
	
	if keyboard_check_pressed(ord("V")) && keyboard_check(vk_control) {
		keyboard_string = clipboard_get_text()
		show_debug_message("Pasted")
	} else if keyboard_check_pressed(ord("C")) && keyboard_check(vk_control) {
		clipboard_set_text(typed_text)
		show_debug_message("Copied")
	}
	
	if string_length(keyboard_string) > 0 {
		var _last_length = string_length(typed_text)
	
		typed_text = string_insert(get_allowed_chars(keyboard_string), typed_text, cursor_position + 1)
		text = typed_text
		
		if max_length > 0 {
			typed_text = string_copy(typed_text, 0, max_length)
		}
		
		if virtual_keyboard.type == kbv_type_numbers {
			var _number_result = number_from_string(typed_text)
			
			if !is_nan(_number_result) && is_real(_number_result) {
				
				if is_real(max_number) {
					_number_result = min(max_number, _number_result)
				}
				
				if is_real(min_number) {
					_number_result = max(min_number, _number_result)
				}
				
				typed_text = string(_number_result)
			}
		}
	
		var _current_length = string_length(typed_text)
	
		cursor_position += _current_length - _last_length
		
		keyboard_string = ""
		input_events.on_text_changed.fire([])
	}
	
	_bg_color = focused_bg_color
	
} else {
	_bg_color = bg_color
}

if string_length(typed_text) <= 0 {
	text = placeholder
	_text_color = placeholder_color
} else {
	text = typed_text
	_text_color = text_color
}