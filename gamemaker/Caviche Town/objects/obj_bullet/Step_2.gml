/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !to_destroy {
	var _raycast = collision_line(xprevious, yprevious, x,y, all, false, true)

	if _raycast != noone {
		
		to_destroy = true
	
		if _raycast.object_index == obj_character && _raycast.current_state != CHARACTER_STATE.DASHING {
			_raycast.apply_damage(damage, shooter)
		} else if _raycast.object_index == obj_character && _raycast.current_state != CHARACTER_STATE.DASHING {
			to_destroy = false
		}
	}
}

