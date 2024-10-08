/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !other.died {
	
	var _current_ammo = other.backpack.get_ammo(type)
	var _max_ammo = other.backpack.get_max_ammo(type)
	var _ammo_space = _max_ammo - _current_ammo
	var _new_ammo = _current_ammo
	
	/*show_debug_message("Giving "+string(amount)+" of ammo")
	show_debug_message("Max ammo "+string(_max_ammo))
	show_debug_message("Current ammo "+string(_current_ammo))
	show_debug_message("Ammo space "+string(_ammo_space))*/


	if _ammo_space >= amount {
		other.backpack.set_ammo(type, _current_ammo + amount)
		amount = 0
	} else if _ammo_space > 0 && _ammo_space < amount {
		amount -= _ammo_space
		other.backpack.set_ammo(type, _max_ammo)
	}
	
		
	//show_debug_message("A character has got "+string(_new_ammo - _current_ammo)+" ammo.")
		
	if amount <= 0 {
		instance_destroy(id)
	}
}