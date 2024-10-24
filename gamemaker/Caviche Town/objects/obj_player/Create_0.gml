/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

audio_falloff_set_model(audio_falloff_linear_distance)
audio_listener_orientation(0, 1, 0, 0, 0, 1)

death_timer = 0

timer = 0

camera_shakeness = 0
camera_shakeness_decrease = 36

camera_distance = 400
_camera_distance = 400

normal_camera_distance = 400

camera = new CameraView(view_camera[0])
character = instance_create_layer(x,y, layer, obj_character)

character.delete_classes_on_dead = false
character.destroy_on_outside = false
character.controller = self
character.sprites = global.characters_sprite_set.hitman()
character.equipped_gun_manager.target_position.x = character.x
character.equipped_gun_manager.target_position.y = character.y

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

android_action_pressed = ""
android_dragging_aim_touch = -1

android_buttons = [
	{
		action:"shoot",
		rel_x:.84,
		rel_y:.75,
		rel_radius:.07,
		sprite: spr_shoot_button
	},
	
	{
		action:"jump",
		rel_x:.68,
		rel_y:.85,
		rel_radius:.04,
		sprite: spr_jump_button
	},
	
	{
		action:"dash",
		rel_x:.57,
		rel_y:.85,
		rel_radius:.04,
		sprite: spr_dash_button
	},
	
	{
		action:"reload",
		rel_x: .73,
		rel_y: .54,
		rel_radius: .045,
		sprite: spr_reload_button
	},
	
	{
		action:"throw_grenade",
		rel_x: .9,
		rel_y: .5,
		rel_radius: .05,
		sprite: spr_throw_grenade_button
	}
]



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

function android_buttons_activity() {

	var _last_android_pressed_action = android_action_pressed
	var _touch = 0

	
	if virtual_joystick.touch == _touch || android_dragging_aim_touch == _touch {
		_touch = 1
	}
	
	if virtual_joystick.touch == _touch || android_dragging_aim_touch == _touch {
		_touch = 2
	}

	if touchscreen_mode && device_mouse_check_button_pressed(_touch, mb_left) {
	
		var _gui_width = display_get_gui_width()
		var _gui_height = display_get_gui_height()
	
		for(var _index = 0; _index < array_length(android_buttons); _index++) {
			var _button = android_buttons[_index]
		
			var _x = _button.rel_x * _gui_width
			var _y = _button.rel_y * _gui_height
			var _radius = _button.rel_radius * _gui_width
		
			var _mouse_distance = point_distance(
				device_mouse_x_to_gui(_touch),
				device_mouse_y_to_gui(_touch),
				_x,
				_y
			)
		
		
			if _mouse_distance <= _radius && device_mouse_check_button(_touch, mb_left) {
				android_action_pressed = _button.action
				break
			}
		}
	
	}

	if device_mouse_check_button_released(_touch, mb_left) {
		android_action_pressed = ""
	}

	if _last_android_pressed_action != android_action_pressed {
		switch android_action_pressed {
			case "reload":
			character.equipped_gun_manager.reload()
			break
		
			case "jump":
			character.jump()
			break
		
			case "throw_grenade":
			character.throw_grenade()
			break
		
			case "dash":
		
			var _joystick_input = get_virtual_joystick_normalized(true)
			character.dash(new Vector(_joystick_input[0], _joystick_input[1]))
		
			break
		}
	}


	if android_action_pressed == "shoot" && !character.died {
		var _gun_information = character.equipped_gun_manager.gun_information
	
		if _gun_information != noone {
			if (!_gun_information.is_auto && _last_android_pressed_action != "shoot") || (_gun_information.is_auto) {
				character.equipped_gun_manager.shoot()
			} 
		}
	}
}

function draw_android_buttons() {
	
	var _gui_width = display_get_gui_width()
	var _gui_height = display_get_gui_height()
	 
	for(var _index = 0; _index < array_length(android_buttons); _index++) {
		var _button_info = android_buttons[_index]
		var _scale = (_gui_width * _button_info.rel_radius*2) / sprite_get_width(_button_info.sprite)
		
		draw_sprite_ext(
			_button_info.sprite,
			0,
			
			_gui_width * _button_info.rel_x,
			_gui_height * _button_info.rel_y,
			_scale,
			_scale,
			0,
			c_white,
			.5
		)
	}
}

function draw_blood_effect() {

	for (var _blood_spot_index = 0; _blood_spot_index < array_length(blood_spots); _blood_spot_index++) {
		var _blood_spot_data = blood_spots[_blood_spot_index]
	
		_blood_spot_data.lifetime -= get_delta()
	
		if _blood_spot_data.lifetime <= 0.3 && !character.died {
			_blood_spot_data.alpha = _blood_spot_data._alpha * (_blood_spot_data.lifetime/0.3)
		}
		
		var _gui_width = display_get_gui_width()
		var _gui_height = display_get_gui_height()
	
		draw_sprite_ext(
			spr_blood_spots,
			_blood_spot_data.subimg,
			_blood_spot_data.x * _gui_width,
			_blood_spot_data.y * _gui_height,
			_blood_spot_data.scale,
			_blood_spot_data.scale,
			0,
			c_white,
			_blood_spot_data.alpha
		)
	
		if _blood_spot_data.lifetime <= 0 && !character.died {
			array_delete(blood_spots, _blood_spot_index, 1)
		}
	}


}

function draw_static_blood_effect() {

	on_low_health_blood_spot_timer += get_delta()

	if character.hp < character.max_hp * .5 {
		
		var _gui_width = display_get_gui_width()
		var _gui_height = display_get_gui_height()
	
		var _top_left_blood_scale = (_gui_width/4)/64
		var _bottom_right_blood_scale = (_gui_width/4)/64
	
		var _alpha = abs(sin(timer*2.5))*.3+.3
	
		show_debug_message(_alpha)
	
		if on_low_health_blood_spot_timer >= 3 * character.hp / (character.max_hp * .5) + .7 {
			create_blood_spot()
			on_low_health_blood_spot_timer = 0
		}
	
		draw_sprite_ext(
			spr_top_left_blood,
			0,
			0,
			0,
			_top_left_blood_scale,
			_top_left_blood_scale,
			0,
			c_white,
			_alpha
		)
	
		draw_sprite_ext(
			spr_bottom_right_blood,
			0,
			_gui_width,
			_gui_height,
			_bottom_right_blood_scale,
			_bottom_right_blood_scale,
			0,
			c_white,
			_alpha
		)
	}


}

function draw_inventory() {
	
	var _gui_width = display_get_gui_width()
	var _slot_count = character.backpack.max_guns
	var _slot_width = (_gui_width * .25) / _slot_count
	var _inventory_width = _slot_width * _slot_count
	var _selected_slot = character.backpack.get_gun_slot(character.equipped_gun_manager.gun_information)
	var _slot_scale = _slot_width / 32
	var _slot_alpha = 1
	
	for(var _drawing_slot_index = 0; _drawing_slot_index < character.backpack.max_guns; _drawing_slot_index++) {
			
		var _sprite_index = spr_slot_center
		var _selected = _selected_slot == _drawing_slot_index
			
		if _drawing_slot_index == 0 && _slot_count > 1 {
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
			
			var _scale = ((_gui_width * .25)/_slot_count) / sprite_get_width(_gun_information.sprite_inventory)
			
			_scale *= _gun_information.scale * .85
			
			draw_sprite_ext(
				_gun_information.sprite_inventory,
				0,
				_x + _slot_width * .5,
				_slot_width * .5,
				_scale,
				_scale,
				_selected ? 25 : 0,
				c_white,
				_selected ? 1 : 0.5
			)
		}
		
	}
	
	
	var _grenade_count = -1
	var _grenade_width = _gui_width*.03
	var _grenade_scale = _grenade_width/sprite_get_width(spr_grenade)
	var _grenades_width = _grenade_width * character.backpack.max_grenades
	
	repeat character.backpack.grenades {
		_grenade_count++
		
		draw_sprite_ext(
			spr_grenade,
			0,
			_gui_width*.5 - _grenades_width * .5 + (_grenade_width*_grenade_count),
			_slot_width + 20,
			_grenade_scale,
			_grenade_scale,
			35,
			c_white,
			1
		)
	}
	
}

function get_virtual_joystick_normalized(_round = false) {
	var _joystick_radius = display_get_gui_width() * global.input_options.touchscreen.virtual_joystick_rel_radius
	
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
	
	var _joystick_radius = display_get_gui_width() * global.input_options.touchscreen.virtual_joystick_rel_radius
	
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
	
	var _joystick_radius =  _gui_width * global.input_options.touchscreen.virtual_joystick_rel_radius
	
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
		var _damage = _args2[1]
		
		create_hit_particle(_hitted_character, _damage)
	})
})

function reset_camera_size() {
	var _window_width = window_get_width()
	var _window_height = window_get_height()
	
	var _width =  _window_width/_window_height * _camera_distance
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

function shoot_pressed() {
	var _is_button_pressed = check_if_pressed("player_do_shoot")
	var _is_mouse_clicked = mouse_check_button_pressed(global.mouse_button_input_keys.player_do_shoot)
	
	return _is_button_pressed || _is_mouse_clicked
}

function draw_aim() {
	if aiming_with_gamepad || touchscreen_mode {
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



