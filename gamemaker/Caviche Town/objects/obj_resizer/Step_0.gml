/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
var _width = window_get_width()
var _height = window_get_height()
		
display_set_gui_size(
	_width,
	_height
)
		
camera_set_view_size(
	view_camera[0],
	_width,
	_height
)
