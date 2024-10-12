// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function UIManager() constructor {
	
	clicked_instances = []
	active_element = noone
	mouse_keeper = noone
	
	function set_mouse_keeper(_canvas_item) {
		if mouse_keeper == noone && argument0 != noone {
			mouse_keeper = argument0
			show_debug_message(string_concat("New mouse keeper: ", object_get_name(_canvas_item.object_index)))
			return
		}
		
		if argument0 == noone || argument0 == undefined || !is_struct(argument0) {
			mouse_keeper = noone
			show_debug_message("Mouse keeper is noone.")
			return
		}
		
		if mouse_keeper.depth > argument0.depth {
			mouse_keeper = argument0
			show_debug_message(string_concat("New mouse keeper: ", object_get_name(_canvas_item.object_index)))
			return
		}
	}
	
	function end_step_event() {
		
		var _clicked_instances_length = array_length(clicked_instances)
		
		if _clicked_instances_length > 0 {
			
			var _focus_grabber = array_last(clicked_instances)
			
			if _focus_grabber == active_element {
				return
			}
			
			if active_element != noone {
				active_element.blur()
			}
			
			
			show_debug_message(string_concat("Focus grabbed by ", object_get_name(_focus_grabber.object_index)))
			
			active_element = _focus_grabber
			active_element.blur()
			
			array_delete(clicked_instances, 0, _clicked_instances_length)
			
		} else if mouse_check_button_released(mb_left) {
			if active_element != noone {
				show_debug_message(string_concat("Focus removed from ", object_get_name(active_element.object_index)))
				active_element.blur()
				active_element = noone
			}
		}
	}
}

global.ui_manager = new UIManager()