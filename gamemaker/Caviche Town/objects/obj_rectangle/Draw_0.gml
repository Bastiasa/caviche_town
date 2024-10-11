/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _render_width = get_render_width()
var _render_height = get_render_height()

if outline_thickness > 0 {
	
	var _outline_position = get_offset_position(-outline_thickness/width, -outline_thickness/height)
	
	draw_sprite_ext(
		spr_whitesquare,
		0,
		_outline_position[0],
		_outline_position[1],
		_render_width + outline_thickness*2*scale_x,
		_render_height + outline_thickness*2*scale_y,
		rotation,
		outline_color,
		alpha
	)
}

draw_sprite_ext(
	spr_whitesquare,
	0,
	x,
	y,
	_render_width,
	_render_height,
	rotation,
	color,
	alpha
)

event_inherited()


/*if outline_thickness > 0 {
	
	var _left_top = get_offset_position()
	var _right_top = get_offset_position(1,0)
	
	var _right_bottom = get_offset_position(1,1)
	var _left_bottom = get_offset_position(0,1)
	
	function draw_line_between(_position_1, _position_2) {
		draw_line_color(
			_position_1[0],
			_position_1[1],
		
			_position_2[0],
			_position_2[1],
		
			outline_color,
			outline_color
		)
	}
	
	draw_line_between(_left_top, _right_top)
	draw_line_between(_right_top, _right_bottom)
	draw_line_between(_right_bottom, _left_bottom)
	draw_line_between(_left_bottom, _left_top)

}*/