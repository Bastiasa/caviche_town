/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _gui_width = display_get_gui_width()
var _gui_height = display_get_gui_height()
	
draw_set_alpha(0.5)
draw_set_color(c_black)
draw_rectangle(0,0, _gui_width, _gui_height, false)
	
draw_set_color(c_white)
draw_set_alpha(1)
	
draw_text(
	_gui_width * .5,
	_gui_height * .5,
	"Esperando a que empiece el juego..."
)
