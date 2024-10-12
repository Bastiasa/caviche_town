/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


if vertical_scroll_enabled && can_scroll() && !keyboard_check(vk_shift) {
	scroll_y -= get_render_height()*.1
}

if horizontal_scroll_enabled && can_scroll() && keyboard_check(vk_shift) {
	scroll_x -= get_render_width()*.1
}