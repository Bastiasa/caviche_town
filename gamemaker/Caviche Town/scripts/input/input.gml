
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
	player_do_throw_gun: ord("Q"),
	
	player_do_equip_slot_1: ord("1"),
	player_do_equip_slot_2: ord("2"),
	player_do_equip_slot_3: ord("3"),
	
	player_do_next_slot: ord("E"),
	player_do_previous_slot: noone,
	
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


