/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _render_width = get_render_width()
var _render_height = get_render_height()

if !surface_exists(content_surface) {
	content_surface = create_surface()
} else {
	surface_resize(content_surface, _render_width - padding_x, _render_height - padding_y)
}

scroll = clamp(scroll, -content_height + _render_height - padding_y, 0)
_scroll = lerp(_scroll, scroll, 0.13)