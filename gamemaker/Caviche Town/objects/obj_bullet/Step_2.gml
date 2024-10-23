/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _delta = delta_time/MILLION

y +=  vertical_speed * _delta

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
	
	return

}

if !to_destroy {
	var _raycast = noone
	var _raycast_list = ds_list_create()
	
	collision_line_list(xprevious, yprevious, x,y, [obj_collider, obj_character], false, true, _raycast_list, true)
	
	if ds_list_size(_raycast_list) > 0 {
		_raycast = _raycast_list[|0]
	}
	
	ds_list_destroy(_raycast_list)
	

	if _raycast != noone {
		
		show_debug_message("Bullet collided with "+object_get_name(_raycast.object_index))
		
		to_destroy = true
	
		if _raycast.object_index == obj_character && !_raycast.is_character_teammate(shooter) && !_raycast.died && _raycast.current_state != CHARACTER_STATE.DASHING {
						
			
			if type != BULLET_TYPE.ROCKET {
				apply_damage_to_target(_raycast)
			}
			
		} else if _raycast.object_index == obj_character && _raycast.current_state != CHARACTER_STATE.DASHING {
			to_destroy = false
		}
		
		if to_destroy {
			play_shoot_sound(_raycast)
		}
	}
}

