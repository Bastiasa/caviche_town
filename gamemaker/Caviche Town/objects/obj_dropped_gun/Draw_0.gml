/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event


if sprite_index > 0 && sprite_exists(sprite_index) {
	
	var _position_x = phy_position_x
	var _position_y = phy_position_y
	var _rotation = -phy_rotation

	var _width = sprite_get_width(sprite_index) * gun_information.scale
	var _height = sprite_get_height(sprite_index) * gun_information.scale

	_position_x -= lengthdir_x(_width*.5, _rotation) + lengthdir_x(_height*.5, _rotation - 90)
	_position_y -= lengthdir_y(_width*.5, _rotation) + lengthdir_y(_height*.5, _rotation - 90)

	if image_yscale < 0 {
	
		_position_x += lengthdir_x(_height, _rotation - 90)
		_position_y += lengthdir_y(_height, _rotation - 90)
	}

	draw_sprite_ext(
		sprite_index,
		0,
		_position_x,
		_position_y,
		image_xscale,
		image_yscale, 
		_rotation,
		c_white,
		1
	)
}


if global.debugging {
	physics_draw_debug()
}

if global.debugging && global.debugging_options.show_dropped_collision_circle {
	
	var _collision_circle_position = [x,y]
	
	draw_set_color(c_purple)
	draw_set_alpha(0.25)
	draw_circle(_collision_circle_position[0], _collision_circle_position[1], collision_circle_radius * gun_information.scale, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
}