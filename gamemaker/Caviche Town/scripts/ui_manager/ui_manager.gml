// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function UIManager() constructor {
	
	clicked_instances = []
	mouse_keepers = []
	active_element = noone
	mouse_keeper = noone
	
	virtual_keyboard_status = "hidden"
	virtual_keyboard_last_height = 0
	
	virtual_keyboard_text_result = ""
	
	function on_virtual_keyboard_status(_status, _height) {
		virtual_keyboard_status = _status
		virtual_keyboard_last_height = _height
		
		show_debug_message("Virtual keyboard status changed.")
	}
	
	function draw_gui() {
		
		if virtual_keyboard_status == "showing" || virtual_keyboard_status == "visible" {
			
			draw_set_color(c_black)
			draw_rectangle(0, 0, room_width, room_height - virtual_keyboard_last_height, false)
			
		}
		
		virtual_keyboard_last_height = keyboard_virtual_height()
	}
	
	function set_mouse_keeper(_canvas_item) {
		if mouse_keeper == noone && argument0 != noone {
			mouse_keeper = argument0
			//show_debug_message(string_concat("New mouse keeper: ", object_get_name(_canvas_item.object_index)))
			return
		}
		
		if argument0 == noone || argument0 == undefined {
			mouse_keeper = noone
			//show_debug_message("Mouse keeper is noone. Given value was "+string(argument0))
			return
		}
		
		if mouse_keeper.depth >= argument0.depth {
			mouse_keeper = argument0
			//show_debug_message(string_concat("New mouse keeper: ", object_get_name(_canvas_item.object_index)))
			return
		}
	}
	
	function _mouse_keeper_check() {
		var _mouse_collision_list = ds_list_create()
		
		
		collision_point_list(mouse_x, mouse_y, obj_canvas_item, false, false, _mouse_collision_list, true)
		
		var _collision_count = ds_list_size(_mouse_collision_list)
		
		if _collision_count > 0 {
			
			var _index = -1
			
			repeat(_collision_count) {
				_index++
				var _mouse_keeper = ds_list_find_value(_mouse_collision_list, _index)
			
				if _mouse_keeper.modal && _mouse_keeper != mouse_keeper {
					set_mouse_keeper(_mouse_keeper)
				}
			}

		} else if mouse_keeper != noone {
			set_mouse_keeper(noone)
		}
		
		delete _mouse_collision_list
	}
	
	function step_event() {
		_mouse_keeper_check()
	}
	
	function end_step_event() {
		
		if keyboard_check_pressed(ord("F")) {
			show_debug_message(string_concat("Mouse keeper: ", (mouse_keeper != noone ? object_get_name(mouse_keeper.object_index) : mouse_keeper)))
		}
		
		var _clicked_instances_length = array_length(clicked_instances)
		//var _mouse_keepers_length = array_length(mouse_keepers)
		
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
			active_element.focus()
			
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