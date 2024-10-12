/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if text_surface == noone || !surface_exists(text_surface) {
	text_surface = create_surface()
}

set_surface(text_surface)

draw_clear_alpha(c_white,0)

surface_reset_target()