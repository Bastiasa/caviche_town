/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if end_timer > 0 {
	var _gui_width = display_get_gui_width()
	var _gui_height = display_get_gui_height()

	draw_set_color(c_black)
	draw_set_alpha(.5)

	draw_rectangle(0, _gui_height*.5-_gui_height*.1*.5, _gui_width, _gui_height*.5+_gui_height*.1, false)

	draw_set_valign(fa_top)
	draw_set_halign(fa_center)
	
	draw_set_color(c_white)
	draw_set_alpha(1)

	draw_text(_gui_width*.5, _gui_height*.5, "GG")

	draw_set_color(c_white)
	draw_set_alpha(1)
}

