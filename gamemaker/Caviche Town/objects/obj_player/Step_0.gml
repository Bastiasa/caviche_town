var _horizontal_direction = keyboard_check(ord("D")) - keyboard_check(ord("A"))
var _delta = delta_time / 1000000


if is_on_floor {
	
	coyote_time = 0
	velocity.y = 0

	if keyboard_check_pressed(vk_space) {
		jump()
	}
	
	if jump_coldown_timer <= 0 {
		velocity.x = clamp(velocity.x + _horizontal_direction * acceleration * _delta, -max_velocity, max_velocity)
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
	
} else {

	
	if coyote_time >= coyote_time_end {
		velocity.y += _gravity * _delta	
		velocity.x -= velocity.x * air_deceleration * _delta
	} else {
		
		if keyboard_check_pressed(vk_space) {
			jump()
		}
		
		coyote_time += _delta
	}
	
	
	
	if meeting_top(1) && is_moving_up() {
		velocity.y *= -.3
	}
	
	if (meeting_left(1) && is_moving_left()) || (meeting_right(1) && is_moving_right()) {
		velocity.x = 0
	}


	
}


