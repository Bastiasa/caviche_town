/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _gui_width = display_get_gui_width()
var _gui_height = display_get_gui_height()

draw_set_font(fnt_ui)

draw_text(
	_gui_width * .1,
	_gui_height * .05,
	"Puerto -> "+string(server_socket.port)
)