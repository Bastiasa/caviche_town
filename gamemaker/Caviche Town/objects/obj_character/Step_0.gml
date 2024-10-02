var _horizontal_direction = keyboard_check(input_codes.right) - keyboard_check(input_codes.left)
var _delta = get_delta()

//show_debug_message(fps)
//show_debug_message(delta_time)

if is_on_floor {
	
	coyote_time = 0
	velocity.y = 0

	if keyboard_check_pressed(input_codes.jump) && jump_coldown_timer <= 0 {
		jump()
	}
	
	
	if jump_coldown_timer > 0 || !was_on_floor || _horizontal_direction == 0 {
		velocity.x = lerp(velocity.x, 0, deceleration * _delta)
	}
	
	if !was_on_floor || jump_coldown_timer > 0 {	
		jump_coldown_timer += _delta
		
		if jump_coldown_timer >= jump_coldown_end {
			jump_coldown_timer = 0
		}
	}
	
	if !was_on_floor {
		current_state = CURRENT_STATE.LANDING
	}
	
	acceleration = walk_acceleration
	max_velocity = walk_velocity

} else {

	
	if coyote_time >= coyote_time_end {
		velocity.y += _gravity * _delta
		velocity.x -= _delta * (velocity.x * air_deceleration)
	} else {
		
		if keyboard_check_pressed(vk_space) {
			jump()
		}
		
		coyote_time += _delta
	}
	
	
	if meeting_top(1) && is_moving_up() {
		velocity.y *= -.3
	}

	
	acceleration = on_air_acceleration
	max_velocity = on_air_velocity
	
	jump_coldown_timer = 0

}


if jump_coldown_timer >= jump_coldown_end || jump_coldown_timer == 0 {
	velocity.x = clamp(velocity.x + _horizontal_direction * acceleration * _delta, -max_velocity, max_velocity)
}


/*if (meeting_left(1) && is_moving_left()) || (meeting_right(1) && is_moving_right()) {
	velocity.x = 0
}*/

if !is_on_floor {
	if meeting_left() && !is_moving_right() && keyboard_check_pressed(input_codes.jump) {
		velocity.y = -walljump_power*_delta
		velocity.x = acceleration
	}

	if meeting_right() && !is_moving_left() && keyboard_check_pressed(input_codes.jump) {
		velocity.y = -jump_power*_delta
		velocity.x = -acceleration*.5
	}
}



if keyboard_check(input_codes.dash) {
	dash()
}

if is_dashing {
	
	if dash_cooldown_timer < dashing_end && dash_direction != noone{
		current_state = CURRENT_STATE.DASHING
		velocity = dash_direction.copy()
	} else if dash_direction != noone {
		dash_direction = noone
		velocity.y *= 0.1
	} else {
		update_direction()
	}

	if dash_cooldown_timer >= dash_cooldown_end {
		is_dashing = false
		dash_cooldown_timer = 0
	} else {
		dash_cooldown_timer += _delta
	}
}

