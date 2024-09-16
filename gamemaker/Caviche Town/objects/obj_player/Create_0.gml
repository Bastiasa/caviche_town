/// @description Insert description here
// You can write your code in this editor


enum CURRENT_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING
}

function Vector(_x,_y) {
	return {"x":_x, "y":_y}
}

function negative_vector(_vector) {
	return Vector(-_vector.x, -_vector.y)
}

function add_vector(_vec1, _vec2) {
	return Vector(_vec1.x + _vec2.x, _vec1.y + _vec2.y)
} 

function substract_vector(_vec1,_vec2) {
	return add_vector(_vec1, negative_vector(_vec2))
}

function multiply_vector(_vector, _other) {
	if is_numeric(_other) {
		return multiply_vector(_vector, Vector(_other,_other))
	} else {
		return Vector(_vector.x*_other.x, _vector.y*_other.y)
	}
}

function divide_vector(_vector, _other) {
	if is_numeric(_other) {
		return multiply_vector(_vector, Vector(1.0/_other, 1.0/_other))
	} else {
		return multiply_vector(_vector, Vector(1.0/_other.x, 1.0/_other.y))
	}
}

function vector_magnitude(_vector) {
	return sqrt(power(_vector.x,2) +power(_vector.y, 2))
}

function vector_direction(_vector) {
	return arctan(_vector.y/_vector.x)
}

animations = {
	standing:[0],
	running:[1,5]
}

timer = 0

_gravity = 9.81

current_camera_id = view_camera[0]
camera_position = Vector(0,0)
camera_size = Vector(camera_get_view_width(current_camera_id), camera_get_view_height(current_camera_id));
velocity = Vector(0,0)

acceleration = 30
max_velocity = 10

was_on_floor = false
is_on_floor = false
is_running = false

jump_power = 1000

current_state = CURRENT_STATE.STANDING
current_animation_frame = 0

image_index = 0
image_speed = 0 

function on_fall_ended(_impact_velocity) {
	show_debug_message(_impact_velocity)
}
