/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _event_type = async_load[?"event_type"]

if _event_type == "virtual keyboard status" {
	var _vk_height = async_load[?"screen_height"]
	var _vk_status = async_load[?"keyboard_status"]
	global.ui_manager.on_virtual_keyboard_status(_vk_status, _vk_height)
}

room_width = window_get_width()
room_height = window_get_height()