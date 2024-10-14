/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


var _type = async_load[?"event_type"]
var _index = async_load[?"pad_index"]

if _type == "gamepad discovered" && !gamepad_is_connected(global.input_options.gamepad.device_id) {
	show_debug_message("New gamepad connected: "+string(_index))
	global.input_options.gamepad.device_id = _index
}