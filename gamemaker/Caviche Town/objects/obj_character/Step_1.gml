/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

position.x = x
position.y = y

is_on_floor = place_meeting(x, y+1, obj_collider) && !is_moving_up()

if (meeting_left() || meeting_right()) && !is_on_floor {
	if _gravity != _walljump_gravity && !is_moving_up() {
		_gravity = _walljump_gravity
	}
	
	velocity.y = min(velocity.y + _walljump_gravity * get_delta() * .5, _walljump_gravity)
	
} else {
	_gravity = _normal_gravity
}

