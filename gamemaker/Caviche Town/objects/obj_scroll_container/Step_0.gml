/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _max_and_min_position = get_min_and_max_position()

var _min_position = _max_and_min_position[0]
var _max_position = _max_and_min_position[1]

scroll_x = clamp(scroll_x, _min_position[0], _max_position[0])
scroll_y = clamp(scroll_y, _min_position[1], _max_position[1])

show_debug_message(scroll_y)

children_offset_x = lerp(children_offset_x, scroll_x, 0.13)
children_offset_y = lerp(children_offset_y, scroll_y, 0.13)

if surface_exists(children_surface) {
	surface_resize(
		children_surface,
		get_render_width(),
		get_render_height()
	)
} else if !surface_exists(children_surface) {
	children_surface = create_surface()
}



