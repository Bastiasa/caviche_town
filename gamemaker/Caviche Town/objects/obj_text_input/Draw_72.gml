/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if surface != noone && !surface_exists(surface) {
	surface = create_surface()
}

set_surface(surface)

draw_clear_alpha(c_white,0)

reset_surface()