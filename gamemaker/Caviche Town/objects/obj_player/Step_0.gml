/// @description Insert description here
// You can write your code in this editor


var _delta = delta_time / 1000000
var _collision_info = move_and_collide(velocity.x,velocity.y, obj_floor)
var _player_position = Vector(x,y)

timer += _delta
camera_position.x = _player_position.x - camera_size.x * .5 + sprite_width * .5
//camera_position.y = camera_size.y * .5 + _player_position.y * .5

camera_set_view_pos(current_camera_id, camera_position.x,camera_position.y)

if keyboard_check(ord("A")) {
	velocity.x = max(velocity.x - acceleration*_delta, -max_velocity)
	current_state = CURRENT_STATE.MOVING_LEFT
} else if keyboard_check(ord("D")) {
	velocity.x = min(velocity.x + acceleration*_delta, max_velocity)
	current_state = CURRENT_STATE.MOVING_RIGHT
} else {
	velocity.x = lerp(velocity.x, 0, .13)
	current_state = CURRENT_STATE.BRAKING
	
	if abs(0 - velocity.x) <= 0.01 {
		current_state = CURRENT_STATE.STANDING
	}
}


/*
show_debug_message(is_on_floor)
show_debug_message(_delta)
show_debug_message(current_state)
*/

is_on_floor = place_meeting(x, y + 1, obj_floor)


for (var _index = 0; _index < array_length(_collision_info); _index ++) {
	var _collided_instance = _collision_info[_index]
	
	is_on_floor = _collided_instance.y > y
	
	if  _collided_instance.y < y && velocity.y < 0 {
		velocity.y *= -.3
	}
	
	if _collided_instance.x < x && velocity.x < 0 {
		velocity.x = 0
	}
	
	if _collided_instance.x > x && velocity.x > 0 {
		velocity.x = 0
	}
}

if !is_on_floor {
	velocity.y += _gravity * _delta
	//current_state = CURRENT_STATE.FALLING
} else {
	
	if !was_on_floor {
		on_fall_ended(velocity.y)
	}
	
	velocity.y = 0
	
	if keyboard_check_pressed(vk_space) {
		show_debug_message("Jumped!")
		velocity.y = -jump_power
	}
}

was_on_floor = is_on_floor

switch current_state {
	case CURRENT_STATE.MOVING_LEFT:
	sprite_index = spr_player_l
	current_animation_frame += 1
	break
	
	case CURRENT_STATE.MOVING_RIGHT:
	sprite_index = spr_player_r
	current_animation_frame += 1
	
	if current_animation_frame >= 5 {
		current_animation_frame = 1
	}
	
	break
	
	case CURRENT_STATE.STANDING or CURRENT_STATE.BRAKING:
	current_animation_frame = 0
	
	if current_animation_frame >= 5 {
		current_animation_frame = 1
	}
	
	break
}

image_index = current_animation_frame







