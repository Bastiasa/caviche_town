/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

timer += delta_time / MILLION

if timer >= animation_duration && timer < buttons_animation_duration + animation_duration {
	var _progress = (timer - animation_duration) / buttons_animation_duration
	
	var _start = .55
	var _spacing = .1
	
	for(var _index = 0; _index < array_length(buttons); _index++) {
		var _button = buttons[_index]
		var _target = _start + _spacing * _index
		
		try {
			_button.relative_position_y = 1.25 + (_target - 1.25) * _progress
			_button.relative_position_x = .5
			_button.modal = false
		} catch(_err) {
		
		}

	}
}

if timer >= animation_duration + buttons_animation_duration && timer < animation_duration + buttons_animation_duration + delta_time / MILLION {
	banner_sprite = spr_bloody_banner
	
	array_foreach(buttons, function(_button) {
		with _button {
			modal = true
		}
	})
}