/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

touchscreen_mode = true

var _touch = event_data[?"touch"]
	
if virtual_joystick.touch == _touch {
	
	var _gui_x = event_data[?"guiposX"]
	var _gui_y = event_data[?"guiposY"]

	show_debug_message(string_concat("Dragging (", _gui_x, ", ", _gui_y, ")"))	
	
	set_virtual_joystick_position(_gui_x, _gui_y)
}
