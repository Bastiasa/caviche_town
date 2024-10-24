/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

audio_listener_position(character.x, character.y, 0)

if touchscreen_mode {
	android_buttons_activity()
}

var _virtual_joystick_movement = get_virtual_joystick_normalized(true)
var _equipped_gun = character.equipped_gun_manager.gun_information

if _equipped_gun != noone {
	camera_distance = get_from_struct(_equipped_gun, "view_distance", normal_camera_distance)
} else {
	camera_distance = normal_camera_distance
}

_camera_distance = lerp(_camera_distance, camera_distance, 1)

reset_camera_size()

timer += get_delta()

var _gamepad_direction = get_gamepad_direction(
	global.gamepad_axis_input_keys.player_x_movement,
	global.gamepad_axis_input_keys.player_y_movement,
	true
)

if check_if_pressed("player_do_jump") {
	character.jump()
}



if check_if_pressed("player_do_dash") {
	
	
	
	if _gamepad_direction != noone && _gamepad_direction.magnitude() != 0 {
		character.dash(_gamepad_direction)
	} else {
		
		var _direction = get_keyboard_input_direction(
			global.keyboard_input_keys.player_move_left,
			global.keyboard_input_keys.player_move_right,
			global.keyboard_input_keys.player_move_up,
			global.keyboard_input_keys.player_move_down
		)
		
		if gamepad_is_connected(global.input_options.gamepad.device_id) && gamepad_is_supported() {
			var _gamepad_buttons_direction = get_gamepad_buttons_direction(
				global.input_options.gamepad.device_id,
				global.gamepad_input_keys.player_move_left,
				global.gamepad_input_keys.player_move_right,
				global.gamepad_input_keys.player_move_up,
				global.gamepad_input_keys.player_move_down
			)
			
			if _gamepad_buttons_direction.magnitude() != 0 {
				_direction = _gamepad_buttons_direction
			}
			
		}
		
		character.dash(_direction)
	}
}

if check_if_pressed("player_do_reload") {
	character.equipped_gun_manager.reload()
}

var _slot_change = check_if_pressed("player_do_next_slot") - check_if_pressed("player_do_previous_slot")

if _slot_change != 0 {
	var _current_slot = character.backpack.get_gun_slot(character.equipped_gun_manager.gun_information)
	var _target_slot = _current_slot + _slot_change
	show_debug_message(string_concat("Gun slot change: ", _current_slot, " + ", _slot_change))
	
	var _reversed =  _slot_change < 0
	var _result = noone
	
	if _current_slot <= -1 || _current_slot >= character.backpack.max_guns {
		_result = character.backpack.first_busy_slot(0, false)
	} else if _target_slot >= character.backpack.max_guns || _target_slot <= -1 {
		_result = character.backpack.first_busy_slot(!_reversed ? 0 : character.backpack.max_guns - 1, _reversed)
		show_debug_message("Getting extreme")
	} else {
		_result = character.backpack.first_busy_slot(_target_slot, _reversed)
		
		if _result == -1 {
			_result = character.backpack.first_busy_slot(!_reversed ? 0 : character.backpack.max_guns - 1, _reversed)
		}
	}
	
	
	if _result != -1 {
		show_debug_message("New slot: "+string(_result))
		character.equipped_gun_manager.set_gun(character.backpack.get_gun(_result))
	} else {
		show_debug_message("Could not find any gun.")
	}

}

for (var _slot = 1; _slot < 4; _slot++) {
	if check_if_pressed("player_do_equip_slot_"+string(_slot)) {
		
		if character.equipped_gun_manager.gun_information == character.backpack.get_gun(_slot-1) {
			character.equipped_gun_manager.set_gun(noone)
		} else {
			character.equipped_gun_manager.set_gun(character.backpack.get_gun(_slot-1))
		}
		
	}
}

if check_if_pressed("player_do_throw_gun") {
	character.throw_gun()
}


if check_if_pressed("player_do_throw_grenade") {
	var _grenade = character.throw_grenade()
	
	if _grenade != undefined {
		_grenade.events.on_exploded.add_listener(function(_args) {
			var _explosion = _args[0]
		
			_explosion.events.on_character_hitted.add_listener(function(_args) {
				var _character = _args[0]
				var _damage = _args[1]
			
				create_hit_particle(_character, _damage)
			})
		})
	}
	

}

var _buttons_direction = check_input("player_move_right") - check_input("player_move_left")



if (_gamepad_direction == noone || _gamepad_direction.magnitude() == 0) && _buttons_direction != 0 {
	character.horizontal_movement = _buttons_direction
} else if _virtual_joystick_movement[0] != 0 && touchscreen_mode {
	character.horizontal_movement = _virtual_joystick_movement[0]
} else if _gamepad_direction != noone {
	character.horizontal_movement = _gamepad_direction.x
} else {
	character.horizontal_movement = 0
}

var _current_delta = delta_time

if abs(_current_delta - last_delta) > 4000 {
	show_debug_message(_current_delta/MILLION)
}

last_delta = _current_delta

var _current_mouse_position = new Vector(mouse_x, mouse_y)
var _mouse_motion = last_mouse_position.subtract(_current_mouse_position)
var _camera_size = camera.get_size()


if (_mouse_motion.magnitude() > 0 || !aiming_with_gamepad) && !touchscreen_mode {
	character.equipped_gun_manager.target_position.x = mouse_x
	character.equipped_gun_manager.target_position.y = mouse_y
	
	aiming_with_gamepad = false
}

if (touchscreen_mode || aiming_with_gamepad) && global.input_options.gamepad.auto_aim && last_aim_gamepad_movement.magnitude() <= 0.3 && android_dragging_aim_touch == -1 {
	var _aim_position = character.equipped_gun_manager.target_position
	var _found_character = instance_nearest(_aim_position.x, _aim_position.y, obj_character)
	
	if !_found_character.died && character.position.distance_to(_found_character.position) <= _camera_size.x*.5 && _found_character.position.distance_to(_aim_position) <= 256 && _found_character != character {
		_aim_position.x = lerp(_aim_position.x, _found_character.x, 0.3)
		_aim_position.y = lerp(_aim_position.y, _found_character.y, 0.3)
		
		show_debug_message("Auto aiming to: "+string(_found_character))
	}
	
}

if last_aim_gamepad_movement.magnitude() > global.input_options.gamepad.aim_death_zone {
	var _aim_position = character.equipped_gun_manager.target_position
	
	_aim_position.x += last_aim_gamepad_movement.x * global.input_options.gamepad.aim_sensitivity * 32
	_aim_position.y += last_aim_gamepad_movement.y * global.input_options.gamepad.aim_sensitivity * 32
	
	var _max_aim_distance =  _camera_size.x*.4
	
	if _aim_position.subtract(character.position).magnitude() > _max_aim_distance {
		var _normal = _aim_position.subtract(character.position).normalize()
		
		_aim_position.x = character.x + _normal.x * _max_aim_distance
		_aim_position.y = character.y + _normal.y * _max_aim_distance
	}
	
	aiming_with_gamepad = true
}


if character.equipped_gun_manager.gun_information != noone {

	var _is_auto = get_from_struct(character.equipped_gun_manager.gun_information, "is_auto", true)
	
	if is_shooting() && !touchscreen_mode && _is_auto {
		character.equipped_gun_manager.shoot()
	}
	
	if shoot_pressed() && !touchscreen_mode && !_is_auto {
		character.equipped_gun_manager.shoot()
	}
}

