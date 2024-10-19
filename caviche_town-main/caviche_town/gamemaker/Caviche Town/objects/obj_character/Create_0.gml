/// @description Insert description here
// You can write your code in this editor

enum CURRENT_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING,
	LANDING,
	JUMPING,
	DASHING,
	WALLSLIDE,
	WALLSLIDE_LEFT,
	WALLSLIDE_RIGHT
}

timer = 0

last_horizontal_direction = 0

particle_manager = new PartcleEmitterManager()
sprite_info = sprite_get_info(sprite_index)

input_codes = {
	left:ord("A"),
	right:ord("D"),
	up: ord("W"),
	down: ord("S"),
	jump: vk_space,
	dash: vk_shift
}

_scale = 4
scale = new Vector(_scale, _scale)

current_state = CURRENT_STATE.STANDING

camera = new CameraView(view_camera[0])

position = new Vector(x,y)
velocity = new Vector(0,0)

timer = 0
timers = {
	dust_on_wallslide:0,
	dust_on_running:0
}

_normal_gravity = 9.81
_wallslide_gravity = 3.8
_walljump_gravity = _wallslide_gravity
_gravity = _normal_gravity


horizontal_collision_velocity = 0

deceleration = 5

walk_velocity = 6.8
walk_acceleration = 30

on_air_velocity = 6.8
on_air_acceleration = 14.9
air_deceleration = .3

acceleration = walk_acceleration
max_velocity = walk_velocity

was_on_floor = false
is_on_floor = false

jump_power = 360
jump_coldown_timer = 0
jump_coldown_end = 4*(1/14)

coyote_time = 0
coyote_time_end = 0.08

// Dash variables

is_dashing = false
dash_speed = 10
on_dash_velocity = noone
dash_direction = noone
dash_cooldown_timer = 0
dashing_end = 0.2
dash_cooldown_end = dashing_end + 1

walljump_power = jump_power * .6

current_sprite_timer = 0

image_yscale = _scale
image_xscale = _scale

function check_collisions() {
	
	if meeting_right(velocity.x) {
		while !meeting_right(sign(velocity.x)) {
			x += sign(velocity.x)
		}
	
		velocity.x = 0
	}

	if meeting_bottom(velocity.y) {
		while !meeting_bottom(sign(velocity.y)) {
			y += sign(velocity.y)
		}
		
		horizontal_collision_velocity = velocity.y	
		velocity.y = 0
	}
}

function get_delta() {
	return delta_time / MILLION
}

function get_sprite_size() {
	return new Vector(sprite_get_width(sprite_index)* scale.x, sprite_get_height(sprite_index)* scale.y)
}

function set_sprite_index_if_isnt(_index) {
	if sprite_index != _index {
		sprite_index = _index
		sprite_info = sprite_get_info(_index)
		
		image_index = 0
		current_sprite_timer = 0
	}
}

function jump() {
	coyote_time = coyote_time_end
	velocity.y = -jump_power * get_delta()
}

function dash() {
	if !is_dashing && current_state != CURRENT_STATE.WALLSLIDE_LEFT && current_state != CURRENT_STATE.WALLSLIDE_RIGHT {
		is_dashing = true
		dash_cooldown_timer = 0
		
		dash_direction = get_input_direction(input_codes.left, input_codes.right, input_codes.up, input_codes.down)
		dash_direction = get_vector_from_magnitude_and_angle(abs(sign(dash_direction.magnitude()))*dash_speed, -dash_direction.angle())
		
		if dash_direction.magnitude() == 0 {
			is_dashing = false
		}
	}
}

function update_direction() {
	if velocity.x > 0 && velocity.x > 1 {
		current_state = CURRENT_STATE.MOVING_RIGHT
		scale.x = _scale
	} else if velocity.x < 0 && velocity.x < -1{
		current_state = CURRENT_STATE.MOVING_LEFT
		scale.x = -_scale
	} else {
		current_state = CURRENT_STATE.STANDING
	}
	
	if velocity.y > 0 {
		current_state = CURRENT_STATE.FALLING
	} else if velocity.y < 0 {
		current_state = CURRENT_STATE.JUMPING
	}
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

function want_go_left() {
	return keyboard_check(input_codes.left)
}

function want_go_right() {
	return keyboard_check(input_codes.right)
}


function meeting_left(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x - _added, y, _obj_index)
}

function meeting_right(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x + _added, y, _obj_index)
}
	
function meeting_bottom(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x, y+_added, _obj_index)
}
	
function meeting_top(_added = 0, _obj_index = obj_collider) {
	return place_meeting(x, y - _added, _obj_index)
}

