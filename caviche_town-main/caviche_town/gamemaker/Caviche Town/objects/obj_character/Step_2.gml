/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

was_on_floor = is_on_floor


move_and_collide(velocity.x,velocity.y, obj_collider)

var _camera_target_position = position.subtract(camera.get_size().multiply(.5))

camera.position = camera.position.linear_interpolate(_camera_target_position, .13)
camera.step()

if current_state != CURRENT_STATE.DASHING && current_state != CURRENT_STATE.LANDING {
	update_direction()
}

check_collisions()

if _gravity == _walljump_gravity {
	if meeting_left() {
		current_state = CURRENT_STATE.WALLSLIDE_LEFT
	} else {
		current_state = CURRENT_STATE.WALLSLIDE_RIGHT
	}
}

switch current_state {
	case CURRENT_STATE.MOVING_RIGHT:
	case CURRENT_STATE.MOVING_LEFT:	
	set_sprite_index_if_isnt(spr_running_player)
	
	
	break
	
	case CURRENT_STATE.STANDING:
	set_sprite_index_if_isnt(spr_idle_player)
	break
	
	case CURRENT_STATE.LANDING:
	set_sprite_index_if_isnt(spr_landing_player)
	break
	
	case CURRENT_STATE.JUMPING:
	set_sprite_index_if_isnt(spr_jumping_player)
	break
	
	case CURRENT_STATE.FALLING:
	set_sprite_index_if_isnt(spr_falling_player)
	break
	
	case CURRENT_STATE.DASHING:
	set_sprite_index_if_isnt(spr_dashing_player)
	break
	
	case CURRENT_STATE.WALLSLIDE:
	case CURRENT_STATE.WALLSLIDE_RIGHT:
	set_sprite_index_if_isnt(spr_wallslide_player)
	scale.x = _scale
	break
	
	case CURRENT_STATE.WALLSLIDE_LEFT:
	set_sprite_index_if_isnt(spr_wallslide_player)
	scale.x = -_scale
	break
}


if sprite_index == spr_jumping_player && image_index >= sprite_info.num_subimages - 1{
	image_speed = 0
} else if sprite_index == spr_running_player {
	image_speed = abs(velocity.x)/max_velocity
} else if sprite_index == spr_landing_player && image_index >= 3 {
	update_direction()
	image_speed = 0
} else {
	image_speed = 1
}

if current_state == CURRENT_STATE.WALLSLIDE_LEFT || current_state == CURRENT_STATE.WALLSLIDE_RIGHT {

	if timer - timers.dust_on_wallslide >= 0.08 && velocity.y > _wallslide_gravity*.5{
		particle_manager.create_particle({
			position:new Vector(x + get_sprite_size().x * .5,y),
			sprite: Sprite14,
			
			min_scale: 1.3,
			max_scale:1.4,
			
			min_lifetime:0.6,
			max_lifetime:0.9
		})
		
		timers.dust_on_wallslide = timer
	}
	
} else if last_horizontal_direction == 0 && is_on_floor && abs(velocity.x) >= max_velocity*.2 {

	if timer - timers.dust_on_running >= 0.08 {
		
		function step_particle(_multiplier = 1) {
			
			var _sprite_size = get_sprite_size()
			
			particle_manager.create_particle({
				position:new Vector(x + _sprite_size.x * .5 * _multiplier, y + _sprite_size.y*.5),
				sprite: Sprite14,
			
				min_scale:0.8,
				max_scale:0.8,
			
				min_lifetime:0.4,
				max_lifetime:0.9
			})
		}
		
		step_particle()
		step_particle(-.5)		
		timers.dust_on_running = timer
	}
}

if false {
	show_debug_message("\nFrame data")
	show_debug_message("Coyote time: "+string(coyote_time))
	show_debug_message("Jump cooldown time: "+string(jump_coldown_timer))
	show_debug_message("Is on floor: "+string(is_on_floor))
	show_debug_message("Is wall sliding: "+string(current_state == CURRENT_STATE.WALLSLIDE_LEFT || current_state == CURRENT_STATE.WALLSLIDE_RIGHT))
	show_debug_message("Is running: "+string(current_state == CURRENT_STATE.MOVING_LEFT || current_state == CURRENT_STATE.MOVING_RIGHT))
	show_debug_message("Is standing: "+string(current_state == CURRENT_STATE.STANDING))
	show_debug_message("Image xscale: "+string(image_xscale))
}

timer += get_delta()

