/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if to_destroy {
	instance_destroy(self.id)
}

if !to_destroy {
	var _raycast = collision_line(xprevious, yprevious, x,y, all, false, true)

	if _raycast != noone {
		
		to_destroy = true
	
		if _raycast.object_index == obj_character && !_raycast.is_character_teammate(shooter) && !_raycast.died && _raycast.current_state != CHARACTER_STATE.DASHING {
			
			var _distance = point_distance(_raycast.x, _raycast.y, start_position_x, start_position_y)
			
			if  _distance > 300 {
				damage = max(5, 300/_distance * damage)
			}
			
			_raycast.apply_damage(damage, shooter)
			events.on_character_hitted.fire([_raycast, self])
		} else if _raycast.object_index == obj_character && _raycast.current_state != CHARACTER_STATE.DASHING {
			to_destroy = false
		}
	}
}

