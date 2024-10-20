/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

move_and_collide(
	velocity.x * get_delta() * 100,
	velocity.y * get_delta() * 100, 
	obj_collider
)

if y >= room_height + 1000 {
	instance_destroy()
}

was_on_floor = is_on_floor

if current_state != CHARACTER_STATE.DASHING && (current_state != CHARACTER_STATE.LANDING || jump_coldown_timer == 0) {
	update_direction()
}

check_collisions()

if _gravity == _wallslide_gravity {
	if meeting_left() {
		current_state = CHARACTER_STATE.WALLSLIDE_LEFT
	} else {
		current_state = CHARACTER_STATE.WALLSLIDE_RIGHT
	}
}

if died {
	current_state = CHARACTER_STATE.DEATH
}

switch current_state {
	case CHARACTER_STATE.MOVING_RIGHT:
	case CHARACTER_STATE.MOVING_LEFT:	
	set_sprite_index_if_isnt(sprites.running)
	break
	
	case CHARACTER_STATE.STANDING:
	set_sprite_index_if_isnt(sprites.idle)
	break
	
	case CHARACTER_STATE.LANDING:
	set_sprite_index_if_isnt(sprites.landing)
	break
	
	case CHARACTER_STATE.JUMPING:
	set_sprite_index_if_isnt(sprites.jump)
	break
	
	case CHARACTER_STATE.FALLING:
	set_sprite_index_if_isnt(sprites.falling)
	break
	
	case CHARACTER_STATE.DASHING:
	set_sprite_index_if_isnt(sprites.dash)
	break
	
	case CHARACTER_STATE.WALLSLIDE:
	case CHARACTER_STATE.WALLSLIDE_RIGHT:
	set_sprite_index_if_isnt(sprites.wallslide)
	scale.x = _scale
	break
	
	case CHARACTER_STATE.WALLSLIDE_LEFT:
	set_sprite_index_if_isnt(sprites.wallslide)
	scale.x = -_scale
	break
	
	case CHARACTER_STATE.DEATH:
	set_sprite_index_if_isnt(sprites.death)
	break
}

if current_state == CHARACTER_STATE.WALLSLIDE_LEFT || current_state == CHARACTER_STATE.WALLSLIDE_RIGHT {
	
	if timer - timers.on_wallslide_dust_timer > 0.05 && velocity.y > _wallslide_gravity*.5 {
		
		var _xoffset = get_sprite_size().x * .5
		
		spawn_dust_particle(
			x+_xoffset,
			y,
			
			.4,
			.55,
			
			.6,
			.9
		)
		
		timers.on_wallslide_dust_timer = timer
	}
	
} else if abs(velocity.x) > max_velocity*.25 && horizontal_movement == 0 && is_on_floor && timer - timers.on_land_dust_timer >= 0.07 {
	
	if !is_dashing || dash_cooldown_timer > dashing_end {
		var _sprite_size = get_sprite_size()
	
		//particle_manager.create_particle(spr_dust_1, _particle_data)
		spawn_dust_particle(
			x,
			y+_sprite_size.y*.5,
			.4,
			.5,
			1.2,
			1.8
		)
		timers.on_land_dust_timer = timer
	}
}


if sprite_index == spr_jumping_player && image_index >= sprite_info.num_subimages - 1{
	image_speed = 0
} else if sprite_index == spr_running_player {
	image_speed = abs(velocity.x)/max_velocity
} else if sprite_index == spr_landing_player && image_index >= 3 {
	image_speed = 0
} else {
	image_speed = 1
}


if keyboard_check(ord("M")) {
	spawn_dust_particle(
	x,y,0.5,3, 1,5, {fade_out:5})
}





if false {
	show_debug_message("\nFrame data")
	show_debug_message("Coyote time: "+string(coyote_time))
	show_debug_message("Jump cooldown time: "+string(jump_coldown_timer))
	show_debug_message("Is on floor: "+string(is_on_floor))
	show_debug_message("Is wall sliding: "+string(current_state == CHARACTER_STATE.WALLSLIDE_LEFT || current_state == CHARACTER_STATE.WALLSLIDE_RIGHT))
	show_debug_message("Is running: "+string(current_state == CHARACTER_STATE.MOVING_LEFT || current_state == CHARACTER_STATE.MOVING_RIGHT))
	show_debug_message("Is standing: "+string(current_state == CHARACTER_STATE.STANDING))
	show_debug_message("Image xscale: "+string(image_xscale))
	show_debug_message("Image xscale: "+string(image_xscale))
}



