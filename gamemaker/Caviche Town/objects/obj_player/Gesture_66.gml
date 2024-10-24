/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !touchscreen_mode return

var _touch = event_data[?"touch"]
	
var _gui_x = event_data[?"guiposX"]
var _gui_y = event_data[?"guiposY"]
	
var _joystick_x = global.input_options.touchscreen.virtual_joystick_rel_x * display_get_gui_width()
var _joystick_y = global.input_options.touchscreen.virtual_joystick_rel_y * display_get_gui_height()
	
var _joystick_radius = global.input_options.touchscreen.virtual_joystick_rel_radius * display_get_gui_width()

var _distance = point_distance(_gui_x,_gui_y,_joystick_x,_joystick_y)
	
if _distance <= _joystick_radius && virtual_joystick.touch == -1 && android_dragging_aim_touch != _touch {
	virtual_joystick.touch = _touch
	virtual_joystick.dragging = true
	
	set_virtual_joystick_position(_gui_x, _gui_y)
} else if _distance >= _joystick_radius && android_dragging_aim_touch == -1 {
	android_dragging_aim_touch = _touch
	var _diff_x = event_data[?"diffX"]
	var _diff_y = event_data[?"diffY"]
	character.equipped_gun_manager.target_position.x += _diff_x * global.input_options.touchscreen.sensitivity
	character.equipped_gun_manager.target_position.y += _diff_y * global.input_options.touchscreen.sensitivity
}

