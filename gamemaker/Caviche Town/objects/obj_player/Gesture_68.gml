/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

touchscreen_mode = true

var _touch = event_data[?"touch"]

if virtual_joystick.touch == _touch {
	virtual_joystick.dragging = false
	virtual_joystick.fg_x = 0
	virtual_joystick.fg_y = 0
}