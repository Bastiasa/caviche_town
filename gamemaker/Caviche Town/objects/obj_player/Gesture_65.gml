/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _tap_x = event_data[?"guiposX"]
var _tap_y= event_data[?"guiposY"]

var _gui_width = display_get_gui_width()
var _slot_count = character.backpack.max_guns
var _slot_width = (_gui_width * .25) / _slot_count
var _inventory_width = _slot_width * _slot_count
var _slot_scale = _slot_width / 32

var _inventory_left  = _gui_width * .5 - _inventory_width * .5
var _inventory_bottom = _slot_width * _slot_scale

var _in_y = _tap_y >= 0 && _tap_y < _inventory_bottom
var _in_x = _tap_x >= _inventory_left && _tap_x < _inventory_left + _inventory_width

if _in_x && _in_y {
	var _rel_x = _tap_x - _inventory_left
	var _slot = (_rel_x / _inventory_width) * _slot_count
	_slot = floor(_slot)
	
	if !character.died {
		character.throw_gun()
	}
}