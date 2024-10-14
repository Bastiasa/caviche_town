/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

type = -1
amount = 0
collision_circle_radius = 0

function on_character_touched(_character) {
	if !_character.died {
	
		var _current_ammo = _character.backpack.get_ammo(type)
		var _max_ammo = _character.backpack.get_max_ammo(type)
		var _ammo_space = _max_ammo - _current_ammo
		var _new_ammo = _current_ammo
	
		/*show_debug_message("Giving "+string(amount)+" of ammo")
		show_debug_message("Max ammo "+string(_max_ammo))
		show_debug_message("Current ammo "+string(_current_ammo))
		show_debug_message("Ammo space "+string(_ammo_space))*/


		if _ammo_space >= amount {
			_character.backpack.set_ammo(type, _current_ammo + amount)
			amount = 0
		} else if _ammo_space > 0 && _ammo_space < amount {
			amount -= _ammo_space
			_character.backpack.set_ammo(type, _max_ammo)
		}
	
		
		//show_debug_message("A character has got "+string(_new_ammo - _current_ammo)+" ammo.")
		
		if amount <= 0 {
			instance_destroy(id)
		}
	}
}