/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

modal = true

children_disposition = CANVAS_ITEM_CHILDREN_DISPOSITION.VERTICAL_LAYOUT

vertical_scroll_enabled = true
horizontal_scroll_enabled = false

scroll_x = 0
scroll_y = 0

scroll_thumbnail_rounded = false
scroll_thumbnail_color = c_white
scroll_thumbnail_margin = 10

function can_scroll() {
	
	if global.ui_manager.active_element == noone && global.ui_manager.mouse_keeper == self {
		return true
	} else {
		return global.ui_manager.active_element == self || has_child(global.ui_manager.active_element)
	}
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
	
	/*_max_x -= children_offset_x
	_min_x -= children_offset_x
	
	_max_y -= children_offset_y
	_min_y -= children_offset_y*/
	
	//show_debug_message(string_concat("Min position: ", _min_x, ", ", _min_y))
	//show_debug_message(string_concat("Max position: ", _max_x, ", ", _max_y))

    return [[_min_x, _min_y], [_max_x, _max_y]];
}