/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
ds_list_destroy(elements)

if surface_exists(content_surface) {
	surface_free(content_surface)
}


delete events.on_element_clicked
delete events.on_element_mouse_move