/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !touchscreen_mode return

var _touch = event_data[?"touch"]
	
if virtual_joystick.touch == _touch {
	
	var _gui_x = event_data[?"guiposX"]
	var _gui_y = event_data[?"guiposY"]

	set_virtual_joystick_position(_gui_x, _gui_y)
} else if android_dragging_aim_touch == _touch {
	var _diff_x = event_data[?"diffX"]
	var _diff_y = event_data[?"diffY"]
	character.equipped_gun_manager.target_position.x += _diff_x * global.input_options.touchscreen.sensitivity
	character.equipped_gun_manager.target_position.y += _diff_y * global.input_options.touchscreen.sensitivity
}
