/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

gun_information = noone
timer = 0
collision_circle_radius = 0

function on_touched_by_character(_character) {
	
	if timer < 0.5 {
		return
	}

	if gun_information != noone && !_character.died && _character.backpack.free_slot() != -1 && !_character.backpack.has_gun(gun_information.name) {
		_character.backpack.put_gun(gun_information, _character.backpack.free_slot())
	
		if _character.equipped_gun_manager.gun_information == noone {
			_character.equipped_gun_manager.set_gun(gun_information)
		}
	
		instance_destroy(id)
	} else if _character.backpack.has_gun(gun_information.name) {
	
		var _current_ammo = _character.backpack.get_ammo(gun_information.bullet_type)
		var _max_ammo = _character.backpack.get_max_ammo(gun_information.bullet_type)
		var _ammo_space = _max_ammo - _current_ammo	
		var _new_ammo = _current_ammo
	
		if _ammo_space > 0 && _ammo_space >= gun_information.loaded_ammo {
			_new_ammo = _current_ammo + gun_information.loaded_ammo
			gun_information.loaded_ammo = 0
		} else if _ammo_space > 0 && _ammo_space < gun_information.loaded_ammo {
			gun_information.loaded_ammo -= _ammo_space
			_new_ammo = _current_ammo + _ammo_space
		}
	
		_character.backpack.set_ammo(gun_information.bullet_type, _new_ammo)
	}
}