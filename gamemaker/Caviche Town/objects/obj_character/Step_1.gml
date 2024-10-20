/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


if y > room_height + 100 && !died {
	apply_damage(max_hp)
	show_debug_message(room_height)
}


position.x = x
position.y = y

timer += get_delta()

is_on_floor = place_meeting(x, y+1, obj_collider) && !is_moving_up()

if (meeting_left() || meeting_right()) && !is_on_floor {
	if _gravity != _wallslide_gravity && !is_moving_up() {
		_gravity = _wallslide_gravity
	}
	
	velocity.y = min(velocity.y + _wallslide_gravity * get_delta() * .5, _wallslide_gravity)
	
} else {
	_gravity = _normal_gravity
}

