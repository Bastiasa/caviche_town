/// @description Insert description here
// You can write your code in this editor

var _delta = delta_time / 1000000

if keyboard_check(ord("A")) {
	hspeed = max(hspeed - acceleration*_delta, -max_velocity)
	current_state = CURRENT_STATE.MOVING_LEFT
} else if keyboard_check(ord("D")) {
	hspeed = min(hspeed + acceleration*_delta, max_velocity)
	current_state = CURRENT_STATE.MOVING_RIGHT
} else {
	hspeed = lerp(hspeed, 0, .13)
	current_state = CURRENT_STATE.BRAKING
	
	if abs(0 - hspeed) <= 0.01 {
		current_state = CURRENT_STATE.STANDING
	}
}

if current_state == CURRENT_STATE.MOVING_LEFT && !place_free(x-1, y) {
	hspeed = 0
} else if current_state == CURRENT_STATE.MOVING_RIGHT && !place_free(x+1, y) {
	hspeed = 0
}

is_on_floor = !place_free(x,y+2)

show_debug_message(is_on_floor)
show_debug_message(_delta)
show_debug_message(current_state)



if !is_on_floor {
	vspeed += 9.81 * _delta
	current_state = CURRENT_STATE.FALLING
} else {
	vspeed = 0
	
	if keyboard_check_pressed(vk_space) {
		vspeed = -jump_power
	}
}





