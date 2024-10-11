/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

children_offset_x = lerp(children_offset_x, scroll_x, 0.13)
children_offset_y = lerp(children_offset_y, scroll_y, 0.13)

for(var _index = 0; _index < array_length(children); _index++) {
	var _child = children[_index]
	
	if _child.surface != children_surface {
		_child.surface = children_surface
	}
}


if surface_exists(children_surface) {
	surface_resize(
		children_surface,
		get_render_width(),
		get_render_height()
	)
} else if !surface_exists(children_surface) {
	children_surface = create_surface()
}



