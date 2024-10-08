var _delta = get_delta()

//show_debug_message(fps)
//show_debug_message(delta_time)

if is_on_floor {
	
	coyote_time = 0
	velocity.y = 0
	
	
	if died || current_state == CHARACTER_STATE.LANDING || horizontal_movement == 0 {
		brake()
	}
	
	if !was_on_floor || jump_coldown_timer > 0 {	
		jump_coldown_timer += _delta
		
		if jump_coldown_timer >= jump_coldown_end {
			jump_coldown_timer = 0
		}
	}
	
	
	if !was_on_floor && last_y_velocity > jump_power*1.5  {
		current_state = CHARACTER_STATE.LANDING
	}
	
	acceleration = walk_acceleration
	max_velocity = walk_velocity

} else {

	
	if coyote_time >= coyote_time_end {
		velocity.y += _gravity * _delta
		velocity.x -= _delta * (velocity.x * air_deceleration)
		
		acceleration = on_air_acceleration
		max_velocity = on_air_velocity
		
	} else {
		
		if current_state == CHARACTER_STATE.LANDING || horizontal_movement == 0 {
			brake()
		}
		
		coyote_time += _delta
	}
	
	
	if meeting_top(1) && is_moving_up() {
		velocity.y *= -.3
	}

	jump_coldown_timer = 0

}


if current_state != CHARACTER_STATE.LANDING && !died {
	velocity.x = clamp(velocity.x + horizontal_movement * acceleration * _delta, -max_velocity, max_velocity)
}


/*if (meeting_left(1) && is_moving_left()) || (meeting_right(1) && is_moving_right()) {
	velocity.x = 0
}*/


if is_dashing {
	
	if dash_cooldown_timer < dashing_end && dash_direction != noone{
		current_state = CHARACTER_STATE.DASHING
		
		velocity.x = dash_direction.x
		velocity.y = dash_direction.y
		
		var _particle_position = new Vector(x,y)
		_particle_position = _particle_position.subtract(dash_direction)
		
		
		if timer - timers.on_dash_dust_timer >= 0.04 {
			
			spawn_dust_particle(
				_particle_position.x,
				_particle_position.y,
				.2,
				1.2,
				.4,
				.7
			)
			
			timers.on_land_dust_timer = timer
		}

		
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

