/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if rotation == 0 {
	x = position_x - get_render_width() * offset_x
	y = position_y - get_render_height() * offset_y
} else {
	
	var _width_offset = get_render_width() * offset_x
	var _height_offset = get_render_height() * offset_y

	var _x_right_position = lengthdir_x(_width_offset, rotation)
	var _y_right_position = lengthdir_y(_width_offset, rotation)
	
	var _x_top_position = lengthdir_x(_height_offset, rotation-90)
	var _y_top_position = lengthdir_y(_height_offset, rotation-90)
	
	x = position_x - _x_right_position - _x_top_position
	y = position_y - _y_right_position - _y_top_position

}

if children_disposition == CANVAS_ITEM_CHILDREN_DISPOSITION.STATIC {
	for(var _child_index = 0; _child_index < array_length(children); _child_index++) {
		var _child = children[_child_index]
		
		if _child == undefined {
			continue 
		}
		
		_child.position_x = children_offset_x
		
		if _child_index == 0 {
			_child.position_y = children_offset_y
		} else {
			var _above_silibing = children[_child_index - 1]
			var _y_position = _above_silibing.y + _above_silibing.get_render_height() + spacing
			_child.position_y = _y_position
		}
	}
}


//is_mouse_inside = (mouse_x > x && mouse_x < x + get_render_width()) && (mouse_y > y && mouse_y < y + get_render_height())