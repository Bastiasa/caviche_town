/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if timer < 0.5 {
	return
}

if gun_information != noone && !other.died && other.backpack.free_slot() != -1 && !other.backpack.has_gun(gun_information.name) {
	other.backpack.put_gun(gun_information, other.backpack.free_slot())
	
	if other.equipped_gun_manager.gun_information == noone {
		other.equipped_gun_manager.set_gun(gun_information)
	}
	
	instance_destroy(id)
} else if other.backpack.has_gun(gun_information.name) {
	
	var _current_ammo = other.backpack.get_ammo(gun_information.bullet_type)
	var _max_ammo = other.backpack.get_max_ammo(gun_information.bullet_type)
	var _ammo_space = _max_ammo - _current_ammo	
	var _new_ammo = _current_ammo
	
	if _ammo_space > 0 && _ammo_space >= gun_information.loaded_ammo {
		_new_ammo = _current_ammo + gun_information.loaded_ammo
		gun_information.loaded_ammo = 0
	} else if _ammo_space > 0 && _ammo_space < gun_information.loaded_ammo {
		gun_information.loaded_ammo -= _ammo_space
		_new_ammo = _current_ammo + _ammo_space
	}
	
	other.backpack.set_ammo(gun_information.bullet_type, _new_ammo)
}