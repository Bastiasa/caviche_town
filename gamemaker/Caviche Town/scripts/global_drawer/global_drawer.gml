// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function GlobalDrawer() constructor {
	
	drawings = []
	
	function save_line(_x1, _y1, _x2, _y2, _color = c_white, _lifetime = 3) {
		array_push(drawings, ["line", _x1, _y1, _x2, _y2, _color, _lifetime])
	}
	
	function save_circle(_x,_y,_radius, _color = c_white, _lifetime = 3) {
		array_push(drawings, ["circle", _x,_y,_radius,_color,_lifetime])
	} 
	
	function draw_end() {
		
		for(var _draw_index = array_length(drawings) - 1; _draw_index >= 0; _draw_index--) {
			var _draw_data = drawings[_draw_index]
			
			if _draw_data[0] == "line" {
				draw_set_color(_draw_data[5])
				draw_line(_draw_data[1], _draw_data[2], _draw_data[3], _draw_data[4])
			} else if _draw_data[0] == "circle" {
				draw_set_color(_draw_data[4])
				draw_circle(_draw_data[1], _draw_data[2], _draw_data[3], false)
			}
			
			_draw_data[array_length(_draw_data) - 1] -= delta_time / MILLION
			
			if array_last(_draw_data) <= 0 {
				array_delete(drawings, _draw_index, 1)
			}
		}
		
		draw_set_color(c_white)
	}
	

}

global.drawer = new GlobalDrawer()