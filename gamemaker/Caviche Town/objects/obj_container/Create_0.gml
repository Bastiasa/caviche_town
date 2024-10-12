/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

children = []
children_surface = create_surface()

disposition = CONTAINER_DISPOSITION.VERTICAL_LAYOUT
spacing = 20


function check_children_surface_existence() {
	if !surface_exists(children_surface) {
		children_surface = create_surface()
	}
}

function create_child(_object_index, _position_x = 0, _position_y = 0) {
	var _new_child = instance_create_layer(_position_x,_position_y, layer, _object_index)
	append_child(_new_child)
	return _new_child
}

function append_child(_canvas_item) {
	array_push(children, _canvas_item)
	_canvas_item.parent = self
	_canvas_item.surface = children_surface
}
