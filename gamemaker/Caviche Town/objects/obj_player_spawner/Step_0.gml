/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _count = 0

with obj_character {
	if !died {
		_count += 1
	}
}

if _count == 1 && !player.character.died {
	end_timer += delta_time / MILLION
}

if end_timer >= 3 {
	room_goto(rm_main_menu)
	
}