/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _sprite_position = new Vector(x,y)
var _sprite_info = sprite_get_info(sprite_index)

if sign(scale.x) == -1 {
	_sprite_position.x += _scale
}

draw_sprite_ext(
	sprite_index,
	image_index,
	_sprite_position.x,
	_sprite_position.y,
	scale.x,
	scale.y,
	0,
	c_white,
	1
)

current_sprite_timer += get_delta() * image_speed

if current_sprite_timer*fps >= _sprite_info.frame_speed {
	image_index = clamp(image_index + 1, 0, _sprite_info.num_subimages - 1)
	current_sprite_timer = 0
}
