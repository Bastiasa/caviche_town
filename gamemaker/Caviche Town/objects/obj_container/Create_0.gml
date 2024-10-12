/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

children = []
children_surface = create_surface()

children_offset_x = 0
children_offset_y = 0

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


function get_min_and_max_position() {
    if array_length(children) <= 0 {
        return array_create(2, 0);
    }
    
    var _min_x = children[0].x;
    var _min_y = children[0].y;
    
    var _max_x = children[0].x;
    var _max_y = children[0].y;
    

    for (var _index = 0; _index < array_length(children); _index++) {
        var _canvas_item = children[_index];
        
        var _left_top = _canvas_item.get_offset_position(0, 0);
        var _right_top = _canvas_item.get_offset_position(1, 0);
        var _left_bottom = _canvas_item.get_offset_position(0, 1);
        var _right_bottom = _canvas_item.get_offset_position(1, 1); 
        
        _min_x = min(_min_x, _left_top[0], _right_top[0], _left_bottom[0], _right_bottom[0]);
        _min_y = min(_min_y, _left_top[1], _right_top[1], _left_bottom[1], _right_bottom[1]);
        
        _max_x = max(_max_x, _left_top[0], _right_top[0], _left_bottom[0], _right_bottom[0]);
        _max_y = max(_max_y, _left_top[1], _right_top[1], _left_bottom[1], _right_bottom[1]);
    }
	
    return [[_min_x, _min_y], [_max_x, _max_y]];
}