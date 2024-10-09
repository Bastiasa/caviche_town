/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if character.died {
	instance_destroy(id)
	return
}


timer += delta_time / MILLION

var _sprite_size = character.get_sprite_size()



if will_be_floor() && !stopped {
	
	if current_direction == 0 && will_be_floor(1) {
		current_direction = 1
	} else if current_direction == 0 && will_be_floor(-1) {
		current_direction = -1
	}
	
} else {
	
	stopped = true
	
	if next_direction == noone {
		next_direction = current_direction * -1
		stopping_time = random_range(5, 8)
		timer = 0
	}
	
	if timer >= stopping_time && next_direction != noone {
		current_direction = next_direction
		next_direction = noone
		stopped = false
	}
	
	current_direction = 0
	
	if first_time && will_be_floor() {
		first_time = false
		stopped = false
		current_direction = next_direction
	}
}

if character.meeting_right(character.velocity.x) {
	current_direction *= -1
}

character.horizontal_movement = current_direction


if target == noone && last_target_position == noone {
	character.equipped_gun_manager.target_position.x = character.x + character.scale.x * 100
	character.equipped_gun_manager.target_position.y = character.y + 1
}


if target != noone || last_target_position != noone {
	
	var _target_position = target != noone ? new Vector(target.x, target.y) : last_target_position
	
	stopped = true
	set_direction_by_position(_target_position.x)
	
	var _gun_target_position = character.equipped_gun_manager.target_position
	
	_gun_target_position.x = lerp(_gun_target_position.x, _target_position.x, aiming_weight)
	_gun_target_position.y = lerp(_gun_target_position.y, _target_position.y, aiming_weight)
	
	if point_distance(character.x, character.y, _target_position.x, _target_position.y) > 200 && will_be_floor(character.scale.x) && !character.meeting_right(100 * sign(character.scale.x)){
		current_direction = character.scale.x
		character.horizontal_movement = character.scale.x
	} else {
		current_direction = 0
		character.horizontal_movement = 0
	}
	
	if target != noone && point_distance(_gun_target_position.x, _gun_target_position.y, target.x,target.y) <= min_target_distance_to_shoot {
		character.equipped_gun_manager.shoot()
		
		if character.equipped_gun_manager.gun_information != noone && character.equipped_gun_manager.gun_information.loaded_ammo <= 0 {
			character.equipped_gun_manager.reload()	
		}
	}
	
	if target == noone && last_target_position != noone {
		timer2 += delta_time / MILLION
		
		if timer2 >= searching_time {
			last_target_position = noone
			current_particle_icon_data = noone
		}
	}
	
	/*var _target_position = character.equipped_gun_manager.target_position
	
	_target_position.x = lerp(_target_position.x, target.position.x, aiming_weight)
	_target_position.y = lerp(_target_position.y, target.position.y, aiming_weight)
	
	if _target_position.distance_to(_target_position) <= 40 && !character.equipped_gun_manager.reloading {
		character.equipped_gun_manager.shoot()
		
		if character.equipped_gun_manager.gun_information.loaded_ammo <= 0 {
			character.equipped_gun_manager.reload()
		}
	}*/
}

var _looking_angle = sign(character.scale.x) > 0 ? 0 : 180

if target != noone {
	_looking_angle = point_direction(character.x, character.y, target.x, target.y)
}

var _looking_front_result = noone
var _player_is_in_view = false


var _this = self

with obj_player {
	var _player_character = other.character
	var _player_character_distance = point_distance(character.x,character.y,_player_character.x,_player_character.y)
	
	
	if _looking_front_result == noone && _player_character_distance <= _this.maximum_view_distance {

		_looking_front_result = _this.look_at(_looking_angle)
		
		if _this.last_target_position != noone {
			var _extra_looking_angle = point_direction(_this.character.x,_this.character.y,_this.last_target_position.x,_this.last_target_position.y)
			var _extra_looking = _this.look_at(_extra_looking_angle)
	
			_looking_front_result = array_concat(_extra_looking, _looking_front_result)
	
		}
		
		_this.check_target_in(_looking_front_result)
		_player_is_in_view = _this.target != noone
	}
}


if !_player_is_in_view && target != noone {
	//current_particle_icon_data = noone
	//show_question_mark()
	
	last_target_position = new Vector(target.x, target.y)
	target = noone
	
	timer2 = 0
}

/*if _raycast_y != noone && _raycast_x != noone {
	_raycast_result = character._collision_line(
		character.x,
		character.y,
		_raycast_x,
		_raycast_y, 
		all,
		false,
		true
	)
}

if _raycast_result != noone && _raycast_result.object_index == obj_character && _raycast_result.player != noone {
	target = _raycast_result
	stopped = true
	next_direction = noone
} else if target != noone && _raycast_result != noone {
	
	if _raycast_result.object_index == obj_collider {
		last_target_position = new Vector(target.x, target.y)
		target = noone
	}
}*/
