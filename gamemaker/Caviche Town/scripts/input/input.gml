keyboard_input_keys = {
	
	// Motion
	
	player_move_left: ord("A"),
	player_move_right: ord("D"),
	player_move_up: ord("W"),
	player_move_down: ord("S"),
	
	// Actions
	
	player_do_jump: vk_space,
	player_do_dash: vk_shift,
	player_do_reload: ord("R")
}

mouse_button_input_keys = {
	player_do_shoot: mb_left,
	player_do_aim: mb_right
}


enum INPUT {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
		
	JUMP,
	DASH,
	
	SHOOT,
	RELOAD,
	AIM
}

function get_input_direction(_left, _right, _up, _down) {
	return new Vector(
		keyboard_check(_right) - keyboard_check(_left),
		keyboard_check(_down) - keyboard_check(_up)
	)
}
