/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

function change_to_spawner(_object_index, _layer, _autodelete = true) {
	var _result = instance_create_layer(0,0, _layer, _object_index)
	
	if _autodelete {
		layer_destroy_instances(layer)
		instance_destroy(id)
	}
	
	
	return _result
}

function set_items_offset(_items_array, _offset_x, _offset_y) {
	for(var _index = 0; _index < array_length(_items_array); _index++) {
		_items_array[_index].offset_x = _offset_x
		_items_array[_index].offset_y = _offset_y
	}
}

function create_canvas_button(_text, _rel_x, _rel_y, _width, _height, _layer = layer) {
	var _button = instance_create_layer(0,0, _layer, obj_button)
	
	_button.text = _text
	_button.relative_position_x = _rel_x
	_button.relative_position_y = _rel_y
	_button.width = _width
	_button.height = _height
	
	return _button
}

function create_canvas_button_with_rel_size(_text, _rel_x, _rel_y, _rel_width, _rel_height, _layer = layer) {
	var _button = instance_create_layer(0,0, _layer, obj_button)
	
	_button.text = _text
	_button.relative_position_x = _rel_x
	_button.relative_position_y = _rel_y
	_button.relative_width = _rel_width
	_button.relative_height = _rel_height
	
	return _button
}

function create_text_input(_placeholder, _rel_x, _rel_y, _width, _height, _rel_width = noone, _rel_height = noone, _layer = layer) {
	var _text_input = instance_create_layer(0,0, _layer, obj_text_input)
	
	_text_input.placeholder = _placeholder
	_text_input.relative_position_x = _rel_x
	_text_input.relative_position_y = _rel_y
	_text_input.width = _width
	_text_input.height = _height
	_text_input.relative_width= _rel_width
	_text_input.relative_height = _rel_height
	
	return _text_input
}