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


if equipped_gun_manager != noone && !died {
	equipped_gun_manager.on_draw_event()
}
if global.debugging && global.debugging_options.show_characters_aim_dot {
	draw_set_color(c_red)
	draw_circle(equipped_gun_manager.target_position.x, equipped_gun_manager.target_position.y, 2, true)
	draw_set_color(c_blue)
	draw_circle(equipped_gun_manager.target_position.x, equipped_gun_manager.target_position.y, 2, false)
	draw_set_color(c_white)
}