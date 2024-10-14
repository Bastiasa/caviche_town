/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if to_destroy {
	
	instance_destroy(self.id)
	
	if global.debugging && global.debugging_options.show_bullets_trayectory {
		if global.drawer != noone {
			global.drawer.save_line(
				start_x,
				start_y,
				x,
				y,
				c_red
			)
		}
	}

}

if !to_destroy {
	var _raycast = noone
	var _raycast_list = ds_list_create()
	
	collision_line_list(xprevious, yprevious, x,y, all, false, true, _raycast_list, true)
	
	if ds_list_size(_raycast_list) > 0 {
		_raycast = _raycast_list[|0]
	}
	
	ds_list_clear(_raycast_list)
	

	if _raycast != noone &&  object_get_parent(_raycast.object_index) != obj_dropped {
		
		show_debug_message("Bullet collided with "+object_get_name(_raycast.object_index))
		
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

