/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _width = display_get_gui_width()
var _height = display_get_gui_height()

var _sprite_width = sprite_get_width(spr_bg)
var _sprite_height = sprite_get_height(spr_bg)

var _scale = 1

var _sprite_aspect_ration = _sprite_width / _sprite_height
var _gui_aspect_ratio = _width / _height

if _sprite_aspect_ration < _gui_aspect_ratio {
	_scale = _width / _sprite_width
} else {
	_scale = _height / _sprite_height
}

draw_sprite_ext(
	spr_bg,
	0,
	_width*.5 - _sprite_width*_scale*.5,
	_height*.5 - _sprite_height*_scale*.5,
	_scale,
	_scale,
	0,
	c_white,
	.9
)