/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

modal = true
elements = []

bg_color = c_black
bg_alpha = 0.3

font = fnt_ui
spacing = 20

scroll = 0
_scroll = 0

padding_x = 0
padding_y = 0

dragging = false
dragging_ended_on = -1

content_surface = -1
content_height = 0

events.on_element_clicked = new Event()
events.on_element_mouse_move = new Event()

draw_element = function (_element_data, _vertical_position = 0, _index = -1) {
	return 0	
}