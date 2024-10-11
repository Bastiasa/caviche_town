/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

position_x = 0
position_y = 0

scale_x = 1
scale_y = 1

width = 0
height = 0

offset_x = 0
offset_y = 0

rotation = 0

visible = true

tmp = {
	sprite_offsets: []
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

function hide() {
	visible = false
}

function show() {
	visible = true
}