/// @description Insert description here
// You can write your code in this editor

enum CURRENT_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING
}

camera = new CameraView(view_camera[0])

position = new Vector(x,y)
velocity = new Vector(0,0)

timer = 0

_gravity = 9.81

deceleration = 5

walk_velocity = 3
run_velocity = 10

walk_acceleration = 10
run_acceleration = 14

acceleration = walk_acceleration
max_velocity = walk_velocity

was_on_floor = false
is_on_floor = false
is_running = false

jump_power = 3.5
jump_coldown_timer = 0
jump_coldown_end = 0.3

coyote_time = 0
coyote_time_end = 0.07

current_state = CURRENT_STATE.STANDING
current_animation_frame = 0

air_deceleration = .3

image_index = 0
image_speed = 0 

function jump() {
	coyote_time = coyote_time_end
	velocity.y = -jump_power
}

function on_fall_ended(_impact_velocity) {
	show_debug_message(_impact_velocity)
}


function is_moving_left() {
	return velocity.x < 0
}

function is_moving_right() {
	return velocity.x > 0
}

function is_moving_up() {
	return velocity.y < 0
}

function meeting_left(_added = 0, _obj_index = obj_floor) {
	return place_meeting(x - _added, y, _obj_index)
}

function meeting_right(_added = 0, _obj_index = obj_floor) {
	return place_meeting(x + _added, y, _obj_index)
}
	
function meeting_bottom(_added = 0, _obj_index = obj_floor) {
	return place_meeting(x, y+_added, _obj_index)
}
	
function meeting_top(_added = 0, _obj_index = obj_floor) {
	return place_meeting(x, y - _added, _obj_index)
}
