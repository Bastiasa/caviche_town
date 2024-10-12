/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

modal = true

children_disposition = CONTAINER_DISPOSITION.VERTICAL_LAYOUT

vertical_scroll_enabled = true
horizontal_scroll_enabled = false

scroll_x = 0
scroll_y = 0

scroll_thumbnail_rounded = false
scroll_thumbnail_color = c_white
scroll_thumbnail_margin = 10

function can_scroll() {
	var _mouse_keeper = global.ui_manager.mouse_keeper
	
	if _mouse_keeper == noone && is_mouse_inside {
		return true
	} else if _mouse_keeper != noone {
		return _mouse_keeper.id == id || has_child(_mouse_keeper)
	}
}

