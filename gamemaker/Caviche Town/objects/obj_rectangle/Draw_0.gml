/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

set_surface(surface)

var _render_width = get_render_width()
var _render_height = get_render_height()

if outline_thickness > 0 {
	
	var _outline_position = get_offset_position(-outline_thickness/width, -outline_thickness/height)
	
	var _outline_x = _render_width + outline_thickness*2*scale_x
	var  _outline_y = _render_height + outline_thickness*2*scale_y
	
	if has_parent() {
		_outline_x -= parent.x
		_outline_y -= parent.y
	}
	
	draw_sprite_ext(
		spr_whitesquare,
		0,
		_outline_position[0],
		_outline_position[1],
		_outline_x,
		_outline_y,
		rotation,
		outline_color,
		alpha
	)
}

var _square_x = x
var _square_y = y

if has_parent() {
	_square_x -= parent.x
	_square_y -= parent.y
}

draw_sprite_ext(
	spr_whitesquare,
	0,
	_square_x,
	_square_y,
	_render_width,
	_render_height,
	rotation,
	color,
	alpha
)

reset_surface()