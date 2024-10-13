/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

timer = 0

camera_shakeness = 0
camera_shakeness_decrease = 50

camera = new CameraView(view_camera[0])
character = instance_create_layer(x,y, layer, obj_character)

character.controller = self
character.sprites = global.characters_sprite_set.hitman()

last_mouse_position = new Vector(mouse_x, mouse_y)
last_aim_gamepad_movement = new Vector()

aiming_with_gamepad = false

camera.update_position = function() {
	var _camera_target_position = character.position
	_camera_target_position = _camera_target_position.subtract(camera.get_size().multiply(.5))

	camera.position = camera.position.linear_interpolate(_camera_target_position, 0.13)
	
	if camera_shakeness > 0 {
		randomize()
		camera.position.x += random_range(-camera_shakeness, camera_shakeness)
		camera.position.y += random_range(-camera_shakeness, camera_shakeness)
	}
	
	camera.step()
}

last_delta = delta_time

hit_particles = []
blood_spots = []

on_low_health_blood_spot_timer = 0

function create_blood_spot() {
	var _hp_critical_index = 1-(character.hp / character.max_hp)
	
	randomize()
	
	var _max_subimages = sprite_get_info(spr_blood_spots).num_subimages
	var _lifetime = random_range(2, _hp_critical_index*14)
	var _alpha =  random_range(0.25, 0.8)
	
	var _blood_spot = {
		x: random_range(-.1,1),
		y: random_range(-.1,1),
		
		scale: random_range(0.5, 1.2) + _hp_critical_index,
		alpha: _alpha,
		_alpha: _alpha,
		subimg: random(_max_subimages),
		lifetime: _lifetime,
		_lifetime: _lifetime
	}
	
	array_push(blood_spots, _blood_spot)
}

function create_hit_particle(_hitted_character,_damage,_lifetime = 2) {
	var _data = {
		character:_hitted_character,
		damage:_damage,
		lifetime:2,
		rotation: random_range(-30, 30)
	}
		
	var _last_index = -1
		
	for(var _index = 0; _index < array_length(hit_particles); _index++) {
		if hit_particles[_index].character == _hitted_character {
			_last_index = _index
			break
		}
	}
		
	if _last_index != -1 {
			
		var _last_particle = hit_particles[_last_index]
			
		_last_particle.damage += _damage
		_last_particle.lifetime = 2
		_last_particle.rotation = random_range(-30,30)
			
		delete _data
	} else {
		array_push(hit_particles,_data)
	}
}

character.events.on_damage.add_listener(function(_args) {
	var _damage_amount = _args[0]
	camera_shakeness = min(camera_shakeness+7, 25)

	
	var _spots_count = random_range(3, 6)

	for (var _count = 0; _count < _spots_count; _count ++) {
		create_blood_spot()
	}
	
	create_hit_particle(character, _damage_amount)
})

character.equipped_gun_manager.events.on_bullet_shooted.add_listener(function(_args) {
	var _bullet = _args[0]
	
	if _bullet == noone || _bullet == undefined {
		return
	}
	
	_bullet.events.on_character_hitted.add_listener(function(_args2) {
		var _hitted_character = _args2[0]
		var _bullet = _args2[1]
		
		create_hit_particle(_hitted_character, _bullet.damage)
	})
})

function check_if_pressed(_input_key_name) {
	var _keyboard_key = get_from_struct(global.keyboard_input_keys, _input_key_name, noone)
	var _gamepad_key = get_from_struct(global.gamepad_input_keys, _input_key_name, noone)
	
	var _is_keyboard_pressed = false
	var _is_gamepad_pressed = false
	
	if _keyboard_key != noone {
		_is_keyboard_pressed = keyboard_check_pressed(_keyboard_key)
	} 
	
	if _gamepad_key != noone && gamepad_is_connected(global.input_options.gamepad.device_id) {
		_is_gamepad_pressed = gamepad_button_check_pressed(global.input_options.gamepad.device_id, _gamepad_key)
	}
	
	return _is_keyboard_pressed || _is_gamepad_pressed
}

function check_input(_input_key_name) {
	var _keyboard_key = get_from_struct(global.keyboard_input_keys, _input_key_name, noone)
	var _gamepad_key = get_from_struct(global.gamepad_input_keys, _input_key_name, noone)
	
	var _is_keyboard_pressed = false
	var _is_gamepad_pressed = false
	
	if _keyboard_key != noone {
		_is_keyboard_pressed = keyboard_check(_keyboard_key)
	} 
	
	if _gamepad_key != noone && gamepad_is_connected(global.input_options.gamepad.device_id) {
		_is_gamepad_pressed = gamepad_button_check(global.input_options.gamepad.device_id, _gamepad_key)
	}
	
	return _is_keyboard_pressed || _is_gamepad_pressed
}

function get_gamepad_direction(_h_axis, _v_axis, _round = false, _default = noone) {
	var _result = new Vector()
	
	if !gamepad_is_connected(global.input_options.gamepad.device_id) || !gamepad_is_supported() {
		return _default
	}
	
	_result.x = gamepad_axis_value(global.input_options.gamepad.device_id, _h_axis)
	_result.y = gamepad_axis_value(global.input_options.gamepad.device_id, _v_axis)
	
	if _round {
		_result.x = round(_result.x)
		_result.y = round(_result.y)
	}
	


	return _result
}

function get_delta() {
	return delta_time / MILLION
}

function is_shooting() {
	var _is_keyboard_or_gamepad_pressed = check_input("player_do_shoot")
	var _is_mouse_clicked = mouse_check_button(global.mouse_button_input_keys.player_do_shoot)
	
	return _is_mouse_clicked || _is_keyboard_or_gamepad_pressed
}

function draw_aim() {
	if aiming_with_gamepad {
		draw_sprite(
			global.input_options.general.aim_sprite,
			0,
			character.equipped_gun_manager.target_position.x - camera.position.x,
			character.equipped_gun_manager.target_position.y - camera.position.y
		)
	
		character.equipped_gun_manager.target_position.x += character.velocity.x * get_delta() * 100
		character.equipped_gun_manager.target_position.y += character.velocity.y * get_delta() * 100
	}
}



