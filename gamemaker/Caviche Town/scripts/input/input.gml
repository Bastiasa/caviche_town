
input_options = {
	general: {
		aim_sprite: spr_aim_01,
		aim_scale: 1,
		
		invert_movement_x_axis: false,
		invert_movement_y_axis: false,
	
		invert_dash_x_axis: false,
		invert_dash_y_axis: false,
	},
	
	gamepad: {
		
		device_id:0,
		
		auto_aim: true,
		
		aim_sensitivity:0.4,
		aim_death_zone:0.7,
		movement_death_zone:0,
		
		invert_gamepad_aim_x_axis: false,
		invert_gamepad_aim_y_axis: false
	},
	
	touchscreen : {
		virtual_joystick_rel_x: .2,
		virtual_joystick_rel_y: .7,
		virtual_joystick_radius: 78,
	}
}

mouse_button_input_keys = {
	player_do_shoot: mb_left
}

keyboard_input_keys = {
	
	// Motion
	
	player_move_left: ord("A"),
	player_move_right: ord("D"),
	player_move_up: ord("W"),
	player_move_down: ord("S"),
	
	// Actions
	
	player_do_shoot: noone,
	player_do_jump: vk_space,
	player_do_dash: vk_shift,
	player_do_reload: ord("R"),
	player_do_throw_gun: noone,//ord("Q"),
	
	player_do_equip_slot_1: ord("1"),
	player_do_equip_slot_2: ord("2"),
	player_do_equip_slot_3: ord("3"),
	
	player_do_next_slot: ord("E"),
	player_do_previous_slot: ord("Q"),
	
	pause_menu: ord("P")
}

gamepad_input_keys = {
	
	// Movement
	
	player_move_left: gp_padl,
	player_move_right: gp_padr,
	player_move_up: gp_padu,
	player_move_down: gp_padd,
	
	// Actions
	
	player_do_jump: gp_face1,
	player_do_dash: gp_face2,
	player_do_reload: gp_face3,
	player_do_throw_gun: gp_face4,
	
	player_do_shoot: gp_shoulderrb,
	
	player_do_equip_slot_1: noone,
	player_do_equip_slot_2: noone,
	player_do_equip_slot_3: noone,
	
	player_do_next_slot: gp_shoulderr,
	player_do_previous_slot: gp_shoulderl,
	
	pause_menu: gp_start
}

gamepad_axis_input_keys = {
	
	player_x_movement: gp_axislh,
	player_y_movement: gp_axislv,
	
	aim_x_movement: gp_axisrh,
	aim_y_movement: gp_axisrv
}


function save_input_settings() {
	
	var _data = {
		input_options: global.input_options,
		mouse_button_input_keys: global.mouse_button_input_keys,
		keyboard_input_keys: global.keyboard_input_keys,
		gamepad_input_keys: global.gamepad_input_keys,
		gamepad_axis_input_keys: global.gamepad_axis_input_keys
	}
	
	var _json_string = json_stringify(_data)
	var _buffer = buffer_create(string_length(_json_string), buffer_grow, 1)
	
	buffer_write(_buffer, buffer_text, _json_string)
	buffer_save(_buffer, "input_settings.json")
	buffer_delete(_buffer)
}

function load_input_settings() {
	var _buffer = buffer_load("input_settings.json")
	
	if _buffer < 0 {
		return false
	} else {
		
		try {
			var _raw_json = buffer_read(_buffer, buffer_text)
			var _json = json_parse(_raw_json, noone, true)	
			
			input_options = _json.input_options
			mouse_button_input_keys = _json.mouse_button_input_keys
			keyboard_input_keys = _json.keyboard_input_keys
			gamepad_input_keys = _json.gamepad_input_keys
			gamepad_axis_input_keys = _json.gamepad_axis_input_keys
			
		} catch(_err) {
			
			show_debug_message("Error while parsing settings content: "+string(_err))
			
		}
		
		buffer_delete(_buffer)
		return true
	}
}

if load_input_settings() {
	 show_debug_message("Input settings have been loaded successfully.")
} else {
	show_debug_message("Input settings have not been loaded correctly. Saving default settings.")
	save_input_settings()
}

function get_keyboard_input_direction(_left, _right, _up, _down) {
	return new Vector(
		keyboard_check(_right) - keyboard_check(_left),
		keyboard_check(_down) - keyboard_check(_up)
	)
}


function get_gamepad_buttons_direction(_device_id, _left, _right, _up, _down) {
	return new Vector(
		gamepad_button_check(_device_id, _right) - gamepad_button_check(_device_id, _left),
		gamepad_button_check(_device_id, _down) - gamepad_button_check(_device_id, _up)
	)
}


