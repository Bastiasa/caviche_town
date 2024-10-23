/// @description Inserte aquí la descripción
// Puede escribir su código en este editor




parent = noone

position_x = x
position_y = y

relative_position_x = noone
relative_position_y = noone

scale_x = 1
scale_y = 1

width = 1
height = 1

relative_width = noone
relative_height = noone

offset_x = 0
offset_y = 0

alpha = 1
background_color = c_white
rotation = 0

is_mouse_inside = false

visible = true

modal = false
focused = false

surface = noone

events = {
	on_mouse_down: new Event(),
	on_mouse_up: new Event(),
	on_mouse_click: new Event(),
	on_mouse_enter: new Event(),
	on_mouse_leave: new Event(),
	
	on_focus: new Event(),
	on_blur: new Event()
}

tmp = {
	sprite_offsets: []
}


function is_mouse_keeper() {
	return  global.ui_manager.mouse_keeper != noone && instance_exists(global.ui_manager.mouse_keeper) && global.ui_manager.mouse_keeper.id == id 
}

function _mouse_entered() {
	events.on_mouse_enter.fire()
}

function _mouse_leave() {
	events.on_mouse_leave.fire()
}

function focus() {
	focused = true
	events.on_focus.fire()
}

function blur() {
	focused = false
	events.on_blur.fire()
}

function reset_surface_target_if_parent_is(_parent_index) {
	if object_get_parent(object_index) == _parent_index {
		reset_surface()
	}
}

function has_parent() {
	return parent != noone && surface == parent.children_surface
}

function set_surface_size(_surface_id) {
	if surface_exists(_surface_id) {
		
		surface_resize(_surface_id,
			max(1,get_render_width()),
			max(1,get_render_height())
		)
	}
}

function set_surface(_surface = surface) {
	if _surface != noone && surface_exists(_surface) {
		surface_set_target(_surface)
	}
}

function create_surface() {
	
	return surface_create(
		max(1,get_render_width()),
		max(1,get_render_height())
	)
}

function reset_surface() {
	if surface != noone {
		surface_reset_target()
	}
}

function get_render_width() {
	var _parent_width = parent == noone ? display_get_gui_width() : parent.get_render_width()
	return relative_width == noone ? width*scale_x : _parent_width * relative_width * scale_x
}

function get_render_height() {
	var _parent_height = parent == noone ? display_get_gui_height() : parent.get_render_height()
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
	
	var _width_offset = get_render_width() * _offset_x
	var _height_offset = get_render_height() * _offset_y
	
	var _x_right_position = lengthdir_x(_width_offset, rotation)
	var _y_right_position = lengthdir_y(_width_offset, rotation)
	
	var _x_top_position = lengthdir_x(_height_offset, rotation-90)
	var _y_top_position = lengthdir_y(_height_offset, rotation-90)
	
	var _result_x = x + _x_right_position + _x_top_position
	var _result_y = y + _y_right_position + _y_top_position
	
	return [_result_x, _result_y]
}

function corners() {
	var _left_top = get_offset_position(0, 0);
    var _right_top = get_offset_position(1, 0);
    var _left_bottom = get_offset_position(0, 1);
    var _right_bottom = get_offset_position(1, 1);

	
	return [_left_top, _right_top, _left_bottom, _right_bottom]
}

function hide() {
	visible = false
}

function show() {
	visible = true
}


function remove() {
	if parent != noone {
		if variable_struct_exists(parent, "remove_child") {
			parent.remove_child(self)
		}
	}
}

children_surface = create_surface()