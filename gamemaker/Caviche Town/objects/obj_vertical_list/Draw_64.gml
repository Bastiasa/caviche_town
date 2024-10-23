/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _render_width = get_render_width()
var _render_height = get_render_height()


draw_set_color(bg_color)
draw_set_alpha(bg_alpha)

draw_roundrect(
	x,
	y,
	x + _render_width,
	y + _render_height,
	false
)


draw_set_color(c_white)
draw_set_alpha(1)

surface_set_target(content_surface)
draw_clear_alpha(c_white, 0)

var _last_element_bottom = _scroll

for(var _index = 0; _index < ds_list_size(elements); _index++) {
	var _element = ds_list_find_value(elements, _index)
	var _y =  _last_element_bottom + spacing
	
	try  {
		_last_element_bottom = draw_element(_element, _y)
	} catch(_err) {
		show_debug_message("Couldn't draw element from list.")
	}
}

content_height = abs(_last_element_bottom - _scroll)

surface_reset_target()
draw_surface(content_surface, x + padding_x * .5, y + padding_y * .5)