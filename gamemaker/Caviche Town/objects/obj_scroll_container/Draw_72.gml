/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

if surface_exists(children_surface) {
	surface_set_target(children_surface)
	
	draw_clear_alpha(c_white, 0)
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	
	surface_reset_target()
}