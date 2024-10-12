/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !is_mouse_inside {
	return
}

if vertical_scroll_enabled {
	scroll_y -= get_render_height()*.5
}
