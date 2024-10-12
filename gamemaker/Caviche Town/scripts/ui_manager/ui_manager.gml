// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function UIManager() constructor {
	
	clicked_instances = []
	
	function end_step_event() {
		
		var _clicked_instances_length = array_length(clicked_instances)
		
		if _clicked_instances_length > 0 {
			
			var _reversed_instances = array_reverse(clicked_instances, 0, _clicked_instances_length)
			
			show_debug_message(string_concat("Focus grabbed by ", object_get_name(_reversed_instances[0].object_index)))
			
			array_delete(clicked_instances, 0, _clicked_instances_length)
		}
	}
}

global.ui_manager = new UIManager()