/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if client_socket.state == UDP_CLIENT_STATE.CONNECTING {
	var _gui_width = display_get_gui_width()
	var _gui_height = display_get_gui_height()
	draw_text(
		_gui_width * .5,
		_gui_height * .5,
		"Conectando..."
	)
}