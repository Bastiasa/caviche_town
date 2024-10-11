/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

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
}

