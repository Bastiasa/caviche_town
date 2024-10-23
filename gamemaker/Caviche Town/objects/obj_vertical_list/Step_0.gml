/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _render_width = get_render_width()
var _render_height = get_render_height()

scroll = clamp(scroll, -content_height + _render_height - padding_y, 0)
_scroll = lerp(_scroll, scroll, 0.13)