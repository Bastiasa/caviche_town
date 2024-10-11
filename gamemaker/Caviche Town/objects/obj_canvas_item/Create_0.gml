/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

enum CANVAS_ITEM_CHILDREN_DISPOSITION {
	FREE,
	STATIC
}


parent = noone

children_disposition = CANVAS_ITEM_CHILDREN_DISPOSITION.FREE 
children = []
spacing = 20

position_x = x
position_y = y

scale_x = 1
scale_y = 1

width = 1
height = 1

relative_width = noone
relative_height = noone

offset_x = 0
offset_y = 0

alpha = 1
color = c_white

clip_content = false

rotation = 0

surface = noone

visible = true

tmp = {
	sprite_offsets: []
}

function create_surface() {
	return surface_create(
		get_render_width(),
		get_render_height()
	)
}

function reset_surface() {
	if surface != noone && surface_exists(surface) {
		surface_reset_target()
	}
}

function get_render_width() {
	var _parent_width = parent == noone ? room_width : parent.get_render_width()
	return relative_width == noone ? width*scale_x : _parent_width * relative_width * scale_x
}

function get_render_height() {
	var _parent_height = parent == noone ? room_height : parent.get_render_height()
	return relative_height == noone ? height*scale_y : _parent_height * relative_height * scale_y
}

function _get_saved_sprite_offset_index(_sprite_index) {
	
	var _result = -1
	
	for(var _index = 0; _index < array_length(tmp.sprite_offsets); _index++) {
		if tmp.sprite_offsets[_index].sprite_index == _sprite_index {
			_result = _index
			break
		}
	}
	
	return _result
}

function _commit_and_delete_sprite_saved_offset(_sprite_index) {
	var _found_index = _get_saved_sprite_offset_index(_sprite_index)
	
	if _found_index != -1 && tmp.sprite_offsets[_found_index] != undefined {
		var _saved_sprite_offset = tmp.sprite_offsets[_found_index]
		sprite_set_offset(_sprite_index, _saved_sprite_offset.offset_x, _saved_sprite_offset.offset_y)
		array_delete(tmp.sprite_offsets, _found_index, 1)
	}
}

function _save_sprite_offset_and_set(_sprite_index, _new_offset_x = 0, _new_offset_y = 0) {
	
	if !sprite_exists(_sprite_index) {
		return
	}
	
	var _found_index = _get_saved_sprite_offset_index(_sprite_index)
	
	if _found_index != -1 && tmp.sprite_offsets[_found_index] != undefined {
		array_push(tmp.sprite_offsets, {
			sprite_index: _sprite_index,
			offset_x: sprite_get_xoffset(_sprite_index),
			offset_y: sprite_get_yoffset(_sprite_index)
		})
	} else {
		found.offset_x = sprite_get_xoffset(_sprite_index)
		found.offset_y = sprite_get_yoffset(_sprite_index)
	}
	
	sprite_set_offset(_sprite_index, _new_offset_x, _new_offset_y)
}

function get_offset_position(_offset_x = 0, _offset_y = 0) {
	
	var _right_magnitude = width*scale_x*_offset_x
	var _top_magnitude = height*scale_y*_offset_y
	
	var _x_right_position = lengthdir_x(_right_magnitude, rotation)
	var _y_right_position = lengthdir_y(_right_magnitude, rotation)
	
	var _x_top_position = lengthdir_x(_top_magnitude, rotation-90)
	var _y_top_position = lengthdir_y(_top_magnitude, rotation-90)
	
	var _result_x = x + _x_right_position + _x_top_position
	var _result_y = y + _y_right_position + _y_top_position
	
	return [_result_x, _result_y]
}



function hide() {
	visible = false
}

function show() {
	visible = true
}

function create_child(_object_index, _position_x = 0, _position_y = 0) {
	var _new_child = instance_create_layer(_position_x,_position_y, layer, _object_index)
	append_child(_new_child)
	return _new_child
}

function append_child(_canvas_item) {
	array_push(children, _canvas_item)
	_canvas_item.parent = self
}

function remove_child(_child) {
	var _found = array_get_index(children, _child)
	
	if _found != -1 {
		_found.parent = noone
		array_delete(children, _found, 1)
	}
}

function remove() {
	if parent != noone {
		if variable_struct_exists(parent, "remove_child") {
			parent.remove_child(self)
		}
	}
}
