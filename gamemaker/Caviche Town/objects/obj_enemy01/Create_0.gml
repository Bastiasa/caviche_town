/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

character = instance_create_layer(x,y, layer, obj_character)

character.sprites = global.characters_sprite_set.default_enemy()
character.walk_velocity = 1 
character.max_velocity = 1

character.backpack.put_gun(get_m16_information(), 0)
character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 200)
character.equipped_gun_manager.set_gun(character.backpack.guns[0])

last_target_position = noone
target = noone

next_direction = noone
current_direction = 1

first_time = false
stopped = false
timer = 0
timer2 = 0
stopping_time = 0

debugging_lines = []
last_looking_front_result = noone

current_particle_icon_data = noone

character.events.on_damage.add_listener(function(_args){
	
	if character.died {
		return
	}
	
	var _damage = _args[0]
	var _from = _args[1]
	
	if _from != noone {
		set_direction_by_position(_from.x)
		
		last_target_position = new Vector(_from.x,_from.y)
	}
})


function show_question_mark() {
	
	if global.particle_manager == noone {
		return
	}
	
	if current_particle_icon_data != noone {
		return	
	}
	
	var _sprite_size = character.get_sprite_size()

	current_particle_icon_data = global.particle_manager.create_particle(
		spr_question_mark,
		{
			position:new Vector(character.x+_sprite_size.x*.5, character.y-_sprite_size.y*.5),
			
			min_lifetime: searching_time,
			max_lifetime: searching_time,
			
			min_scale:1,
			max_scale:1,
			
			animation_params: {
				fade_out:1
			}
		},
		
		-1
	)
}

function set_direction_by_position(_x) {
	var _target_x_scale = -sign(character.position.x - _x) * character._scale
	
	if _target_x_scale != 0 {
		character.scale.x = _target_x_scale
	}
}

function show_discover_check() {
	
	if global.particle_manager == noone {
		return
	}
	
	if current_particle_icon_data != noone {
		return	
	}
	
	var _sprite_size = character.get_sprite_size()

	current_particle_icon_data = global.particle_manager.create_particle(
		spr_discover_check,
		{
			position:new Vector(character.x+_sprite_size.x*.5, character.y-_sprite_size.y*.5),
			
			min_lifetime:3,
			max_lifetime:3,
			
			min_scale:1,
			max_scale:1,
			
			animation_params: {
				fade_out:1
			}
		},
		
		-1
	)
}

function tell_to_others() {
	with obj_enemy01 {
		
		if other == self {
			continue
		}
		
		var _ally_distance = point_distance(character.x,character.y, other.character.x, other.character.y)
		
		if _ally_distance < 400 && target == noone {
			show_debug_message("Yelled to ally!")
			target = other.target
			show_discover_check()
		}
		
	}
}

function will_be_floor(_direction = current_direction) {
	var _sprite_size = character.get_sprite_size()
	
	var _future_x_position = character.x + sign(_direction) * character.acceleration * 1.5
	var _future_y_position = character.y + _sprite_size.y * .5 + 2
	
	if global.debugging && global.debugging_options.show_enemies_floor_dot {
		draw_set_color(c_red)
		draw_circle(_future_x_position,_future_y_position, 2, 0)
		draw_set_color(c_white)
	}
	
	return !position_empty(_future_x_position,_future_y_position)
}

function look_at(_direction, _view_range = 3, _spacing = 5, debugging = true) {
	
	var _result = []
	var _angle = _direction - _view_range
	
	for(var _count = _direction - _view_range; _count < _direction + _view_range; _count += 1) {
		var _x2 = lengthdir_x(maximum_view_distance, _angle) + character.x
		var _y2 = lengthdir_y(maximum_view_distance, _angle) + character.y
		
		var _list = ds_list_create()
		
		var _raycast_result = character._collision_line_list(
			character.x,
			character.y,
			_x2,
			_y2,
			all,
			false,
			true,
			_list,
			true
		)
		
		_angle += _spacing
		array_push(_result, _list)
		
		if global.debugging {
			array_push(debugging_lines, [character.x,character.y,_x2,_y2])
		}
	
	}
	
	return _result
}

function check_target_in(_collision_line_list_array) {
	
	var _player_is_in_view = false
	
	for(var _index = 0; _index < array_length(_collision_line_list_array); _index++) {
		var _instances_list = _collision_line_list_array[_index]
	
		var _current_instance_index = 0
		var _first_instance = _instances_list[|_current_instance_index]
	
		if _player_is_in_view {
			delete _instances_list
			continue
		}
	
		if _first_instance != undefined {
			
			while _first_instance != undefined && _first_instance.object_index == obj_character && _first_instance.player == noone {
				_current_instance_index++
				_first_instance = _instances_list[|_current_instance_index]
			}
			
			if _first_instance == undefined {
				delete _instances_list
				continue
			}
			
			if _first_instance.object_index == obj_character && _first_instance.player != noone {
				show_discover_check()
				target = _first_instance
				last_target_position = noone
				_player_is_in_view = true
				tell_to_others()
			}
		} else {
			delete _instances_list
			continue
		}
	
		delete _instances_list
	}
	
	return _player_is_in_view
}
