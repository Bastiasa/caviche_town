/// @description Insert description here
// You can write your code in this editor


enum CURRENT_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING
}

animations = {
	standing:[0],
	running:[]
}

acceleration = 30
max_velocity = 10

is_on_floor = false
is_running = false

jump_power = 7


current_state = CURRENT_STATE.STANDING
current_animation_frame = 0


image_index = 0
image_speed = 0