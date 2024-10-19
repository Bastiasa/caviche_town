/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

timer = 0

camera_shakeness = 0
camera_shakeness_decrease = 50

camera_distance = 400

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

touchscreen_mode = os_type == os_android || os_type == os_ios || os_type == os_unknown

virtual_joystick = {
	rel_x: .2,
	rel_y: .7,
	radius: 78,
	
	_fg_x: 0,
	_fg_y: 0,
	fg_x: 0,
	fg_y: 0,
	
	dragging: false,
	touch: -1
}

character.equipped_gun_manager.events.on_bullet_shooted.add_listener(function(_args) {
	
	if character.equipped_gun_manager == noone {
		return
	}
	
	var _camera_shake_enabled = get_from_struct(character.equipped_gun_manager.gun_information, "player_camera_shake", false)
	var _camera_shake_amount = get_from_struct(character.equipped_gun_manager.gun_information, "player_camera_shake_amount", 0)
	
	if _camera_shake_enabled {
		camera_shakeness += _camera_shake_amount
	}
})

function draw_inventory() {
	
	var _gui_width = display_get_gui_width()
	var _slot_count = character.backpack.max_guns
	var _slot_width = (_gui_width * .25) / _slot_count
	var _inventory_width = _slot_width * _slot_count
	var _selected_slot = character.backpack.get_gun_slot(character.equipped_gun_manager.gun_information)
	var _slot_scale = _slot_width / 32
	var _slot_alpha = 1
	
	if _slot_count == 1 {
		draw_sprite_ext(
			spr_slot_center,
			_selected_slot == 0 ? 1 : 0,
			x - _inventory_width * .5,
			0,
			_slot_scale,
			_slot_scale,
			0,
			c_white,
			_slot_alpha
		)
	} else {
		for(var _drawing_slot_index = 0; _drawing_slot_index < character.backpack.max_guns; _drawing_slot_index++) {
			
			var _sprite_index = spr_slot_center
			var _selected = _selected_slot == _drawing_slot_index
			
			if _drawing_slot_index == 0 {
				_sprite_index = spr_slot_left
			} else if _drawing_slot_index == character.backpack.max_guns - 1 {
				_sprite_index = spr_slot_right
			}
			
			var _x  = _gui_width * .5 - _inventory_width * .5 + (_drawing_slot_index * _slot_width)
			
			draw_sprite_ext(
				_sprite_index,
				_selected,
				_x,
				0,
				_slot_scale,
				_slot_scale,
				0,
				c_white,
				_slot_alpha
			)
			
			var _gun_information = character.backpack.get_gun(_drawing_slot_index)
			
			if _gun_information != noone {
				draw_sprite_ext(
					_gun_information.sprite,
					0,
					_x + (_slot_width*.5) - sprite_get_width(_gun_information.sprite) * .5,
					_slot_width * .5,
					1,
					1,
					_selected ? 25 : 0,
					c_white,
					_selected ? 1 : 0.5
				)
			}
		
		}
	}
	
}

function get_virtual_joystick_normalized(_round = false) {
	var _joystick_radius = global.input_options.touchscreen.virtual_joystick_radius
	
	var _result = [
		virtual_joystick._fg_x / _joystick_radius,
		virtual_joystick._fg_y / _joystick_radius
	]
	
	if _round {
		_result[0] = round(_result[0])
		_result[1] = round(_result[1])
	}
	
	return _result
}

function set_virtual_joystick_position(_gui_x, _gui_y) {
	
	var _joystick_radius = global.input_options.touchscreen.virtual_joystick_radius
	
	var _joystick_x = global.input_options.touchscreen.virtual_joystick_rel_x * display_get_gui_width()
	var _joystick_y = global.input_options.touchscreen.virtual_joystick_rel_y * display_get_gui_height()
	
	virtual_joystick.fg_x = _gui_x - _joystick_x
	virtual_joystick.fg_y = _gui_y - _joystick_y
	
	if point_distance(0,0,virtual_joystick.fg_x, virtual_joystick.fg_y) > _joystick_radius {
		var _direction = point_direction(0,0, virtual_joystick.fg_x, virtual_joystick.fg_y)
		virtual_joystick.fg_x = lengthdir_x(_joystick_radius, _direction)
		virtual_joystick.fg_y = lengthdir_y(_joystick_radius, _direction)
	}
}

function draw_virtual_joystick(_gui_width, _gui_height) {
	
	var _joystick_x = _gui_width * global.input_options.touchscreen.virtual_joystick_rel_x
	var _joystick_y = _gui_height * global.input_options.touchscreen.virtual_joystick_rel_y
	
	var _joystick_radius = global.input_options.touchscreen.virtual_joystick_radius
	
	draw_set_circle_precision(_joystick_radius*.5)
	draw_set_alpha(0.4)
	
	draw_set_color(c_black)
	
	draw_circle(
		_joystick_x,
		_joystick_y,
		_joystick_radius,
		false
	)

	draw_set_color(c_white)
	
	draw_circle(
		_joystick_x,
		_joystick_y,
		_joystick_radius,
		false
	)
	
	draw_set_circle_precision(_joystick_radius*.25)

	virtual_joystick._fg_x = lerp(virtual_joystick._fg_x, virtual_joystick.fg_x, 0.2)
	virtual_joystick._fg_y = lerp(virtual_joystick._fg_y, virtual_joystick.fg_y, 0.2)

	draw_circle(
		_joystick_x + virtual_joystick._fg_x,
		_joystick_y + virtual_joystick._fg_y,
		_joystick_radius * .5,
		false
	)
	
	

	
	draw_set_alpha(1)
	draw_set_circle_precision(32)
}

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

function reset_camera_size() {
	var _window_width = window_get_width()
	var _window_height = window_get_height()
	
	var _width =  _window_width/_window_height * camera_distance
	var _height = camera_distance
	
	camera.size.x = _width
	camera.size.y = _height
	
	view_wport[0] = _width
	view_hport[0] = _height
	
	display_set_gui_size(_width, _height)
	
}

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



