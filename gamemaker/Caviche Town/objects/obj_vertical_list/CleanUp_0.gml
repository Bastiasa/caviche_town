/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
if content_surface != noone && surface_exists(content_surface) && surface_get_target() != content_surface {
	surface_free(content_surface)
}

content_surface = noone