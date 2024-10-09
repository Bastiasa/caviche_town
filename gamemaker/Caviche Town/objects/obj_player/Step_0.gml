/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

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

	show_debug_message(string_concat(_current_slot, " + ", _slot_change))

	if _current_slot == -1 {
		_current_slot = character.backpack.first_busy_slot()
		
		
		
		if _current_slot != -1 {
			character.equipped_gun_manager.set_gun(character.backpack.get_gun(_current_slot))
		}
	} else {
		var _next_slot = _current_slot + _slot_change
		
		if _next_slot >= character.backpack.max_guns {
			_next_slot = 0
		} else if _next_slot < 0 {
			_next_slot = character.backpack.max_guns - 1
		}
		
		var _gun = character.backpack.get_gun(_next_slot)
		
		if _gun != noone {
			character.equipped_gun_manager.set_gun(_gun)
		}
	}
	
	
}

for (var _slot = 1; _slot < 4; _slot++) {
	if check_if_pressed("player_do_equip_slot_"+string(_slot)) {
		character.equipped_gun_manager.set_gun(character.backpack.get_gun(_slot-1))
	}
}

if check_if_pressed("player_do_throw_gun") {
	if character.equipped_gun_manager.gun_information != noone && !character.equipped_gun_manager.reloading && !character.equipped_gun_manager.equipping {
		var _dropped_position = character.equipped_gun_manager.get_offset_position()
		var _gun_information = character.equipped_gun_manager.gun_information
		var _backpack_index = array_get_index(character.backpack.guns, _gun_information)
		
		if _backpack_index != -1 {
			character.backpack.remove_gun(_backpack_index)
		}
		
		var _dropped_gun = character.create_dropped_gun(_gun_information)
		var _camera_size = camera.get_size()
		
		_dropped_gun.x = _dropped_position.x + character.x
		_dropped_gun.y = _dropped_position.y + character.y
		
		_dropped_gun.x += _dropped_position.normalize().x * sprite_get_width(_gun_information.sprite) * _gun_information.scale
		_dropped_gun.y += _dropped_position.normalize().y * sprite_get_height(_gun_information.sprite) * _gun_information.scale
		
		show_debug_message(character.equipped_gun_manager._rotation)
		
		_dropped_gun.x_scale = _gun_information.scale
		_dropped_gun.y_scale = character.equipped_gun_manager.get_direction() * _gun_information.scale
		_dropped_gun.image_angle = abs(character.equipped_gun_manager._rotation) 
		
		_dropped_gun.vertical_speed = (character.equipped_gun_manager.target_position.y - character.y)/_camera_size.y * 10
		_dropped_gun.horizontal_speed = (character.equipped_gun_manager.target_position.x - character.x)/_camera_size.x * 10
		_dropped_gun.angular_speed = 10 * character.equipped_gun_manager.get_direction()
		
		_dropped_gun.vertical_speed = clamp(_dropped_gun.vertical_speed, -5, 5)
		_dropped_gun.horizontal_speed = clamp(_dropped_gun.horizontal_speed, -5, 5)
		
		character.equipped_gun_manager.set_gun(noone)
	}
}

if _gamepad_direction == noone || _gamepad_direction.magnitude() == 0 {
	character.horizontal_movement = check_input("player_move_right") - check_input("player_move_left")
} else {
	character.horizontal_movement = _gamepad_direction.x
}

var _current_delta = delta_time

if abs(_current_delta - last_delta) > 4000 {
	show_debug_message(_current_delta/MILLION)
}

last_delta = _current_delta

var _current_mouse_position = new Vector(mouse_x, mouse_y)
var _mouse_motion = last_mouse_position.subtract(_current_mouse_position)
var _camera_size = camera.get_size()


if _mouse_motion.magnitude() > 0 || !aiming_with_gamepad {
	character.equipped_gun_manager.target_position.x = mouse_x
	character.equipped_gun_manager.target_position.y = mouse_y
	
	aiming_with_gamepad = false
}

if aiming_with_gamepad && global.input_options.gamepad.auto_aim && last_aim_gamepad_movement.magnitude() <= 0.3 {
	var _aim_position = character.equipped_gun_manager.target_position
	var _found_character = instance_nearest(_aim_position.x, _aim_position.y, obj_character)
	
	if !_found_character.died && character.position.distance_to(_found_character.position) <= _camera_size.x*.5 && _found_character.position.distance_to(_aim_position) <= 256 && _found_character != character {
		_aim_position.x = lerp(_aim_position.x, _found_character.x, 0.15)
		_aim_position.y = lerp(_aim_position.y, _found_character.y, 0.15)
		
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


if is_shooting() {
	character.equipped_gun_manager.shoot()
}
