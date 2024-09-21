/// @description Insert description here
// You can write your code in this editor


enum CURRENT_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING
}

created_vectors = []

velocity = Vector(1,1)

var a = Vector(1,1)
var b = Vector(2,2)


show_debug_message(a)



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
