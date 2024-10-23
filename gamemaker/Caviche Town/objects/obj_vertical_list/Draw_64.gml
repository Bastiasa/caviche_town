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


if elements != noone {
	surface_set_target(content_surface)
	draw_clear_alpha(c_white, 0)

	var _last_element_bottom = _scroll

	for(var _index = 0; _index < array_length(elements); _index++) {
		var _element = array_get(elements, _index)
		var _y =  _last_element_bottom + spacing
	
		try  {
			_last_element_bottom = _y + draw_element(_element, _y, _index)
		
			if is_mouse_keeper() {
			
				var _rel_mouse_x = mouse_x - x - padding_x * .5
				var _rel_mouse_y = mouse_y - y - padding_y * .5
			
				var _clicked = mouse_check_button_released(mb_left)
				var _dragging_end_difference = current_time - dragging_ended_on
				var _delta = delta_time / MILLION * 2
			
				if _dragging_end_difference >=  _delta * 1000 &&  _rel_mouse_y >= _y && _rel_mouse_y < _last_element_bottom && !dragging {				
					events.on_element_mouse_move.fire([_element, _index, _rel_mouse_x, _rel_mouse_y])
				
					if _clicked {
						events.on_element_clicked.fire([_element, _index, _rel_mouse_x, _rel_mouse_y])
					}
				}
			}
		
		} catch(_err) {
			show_debug_message("Couldn't draw element from list. "+string(_err))
		}
	}

	content_height = abs(_last_element_bottom - _scroll)

	surface_reset_target()
	draw_surface(content_surface, x + padding_x * .5, y + padding_y * .5)
}

