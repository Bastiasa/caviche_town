/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


var _sprite_width = sprite_get_width(sprite_index)
var _sprite_height = sprite_get_height(sprite_index)

var _sprite_offset_x = sprite_get_xoffset(sprite_index)
var _sprite_offset_y = sprite_get_yoffset(sprite_index)

sprite_set_offset(sprite_index, _sprite_width*.5, _sprite_height*.5)
draw_sprite_ext(
	sprite_index,
	image_index,
	x, //- _sprite_offset_x * _sprite_width,
	y, //- _sprite_offset_y * _sprite_height,
	x_scale,
	y_scale,
	rotation,
	c_white,
	1
)


sprite_set_offset(sprite_index, _sprite_offset_x, _sprite_offset_y)