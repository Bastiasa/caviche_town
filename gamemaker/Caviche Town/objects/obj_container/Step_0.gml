/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();
check_children_surface_existence()
set_surface_size(children_surface)

for(var _index = 0; _index < array_length(children); _index++) {
	var _child = children[_index]
	
	if _child.surface != children_surface {
		_child.surface = children_surface
	}
}


if disposition == CONTAINER_DISPOSITION.VERTICAL_LAYOUT {
	
	for(var _child_index = 0; _child_index < array_length(children); _child_index++) {
		var _child = children[_child_index]
		
		if _child == undefined {
			continue 
		}
		
		_child.position_x = x + children_offset_x
		
		if _child_index == 0 {
			_child.position_y = y + children_offset_y
		} else {
			var _above_silibing = children[_child_index - 1]
			var _y_position = _above_silibing.y + _above_silibing.get_render_height() + spacing
			_child.position_y = _y_position
		}
	}
}