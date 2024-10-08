/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if character.died {
	return
}

will_be_floor()

if global.debugging && global.debugging_options.show_enemies_raycast {
	for (var _index = 0; _index < array_length(debugging_lines); _index++) {
		var _line_data = debugging_lines[_index]
		
		draw_line_color(
			_line_data[0],
			_line_data[1],
			_line_data[2],
			_line_data[3],
			c_blue,
			c_blue
		)
		
		array_delete(debugging_lines, _index, 1)
	}
}

if current_particle_icon_data != noone {
	var _sprite_size = character.get_sprite_size()

	current_particle_icon_data.position.x = character.x+_sprite_size.x*.5
	current_particle_icon_data.position.y = character.y-_sprite_size.y*.5
}

/*if target != noone {
	
	_raycast_x = target.x
	_raycast_y = target.y
	
} else if last_target_position != noone {
	_raycast_y = last_target_position.y
	_raycast_x = last_target_position.x
	
	var _angle = point_direction(character.x,character.y, _raycast_x,_raycast_y)
	var _view = 10
	
	for (var _count = _angle - _view; _count < _angle + _view; _count++) {
		draw_line_color(
			character.x,
			character.y,
			lengthdir_x(maximum_view_distance, _count) + character.x,
			lengthdir_y(maximum_view_distance, _count) + character.y,
			c_red,
			c_red
		)
	}
}*/

//draw_line_color(character.x, character.y, _raycast_x, _raycast_y, c_red, c_red)