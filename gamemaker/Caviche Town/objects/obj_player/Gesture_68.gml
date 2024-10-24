/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !touchscreen_mode return

var _touch = event_data[?"touch"]

if virtual_joystick.touch == _touch {
	virtual_joystick.touch = -1
	virtual_joystick.dragging = false
	virtual_joystick.fg_x = 0
	virtual_joystick.fg_y = 0
} else if android_dragging_aim_touch == _touch {
	android_dragging_aim_touch = -1
}