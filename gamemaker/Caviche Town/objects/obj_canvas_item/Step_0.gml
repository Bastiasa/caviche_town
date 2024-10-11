/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if surface_get_width(surface) != width*scale_x || surface_get_height(surface) != height*scale_y {
	surface_resize(surface, width*scale_x, height*scale_y)
}


if rotation == 0 {
	x = position_x - width * scale_x * offset_x
	y = position_y - height * scale_y * offset_y
} else {
	
	var _right_magnitude = width*scale_x*offset_x
	var _top_magnitude = height*scale_y*offset_y
	
	var _x_right_position = lengthdir_x(_right_magnitude, rotation)
	var _y_right_position = lengthdir_y(_right_magnitude, rotation)
	
	var _x_top_position = lengthdir_x(_top_magnitude, rotation-90)
	var _y_top_position = lengthdir_y(_top_magnitude, rotation-90)
	
	x = position_x - _x_right_position - _x_top_position
	y = position_y - _y_right_position - _y_top_position

}

if children_disposition == CANVAS_ITEM_CHILDREN_DISPOSITION.STATIC {
	for(var _child_index = array_length(children) - 1; _child_index >= 0; _child_index--) {
		var _child = children[_child_index]
		
		if _child == undefined {
			continue 
		}
		
		
	}
}
