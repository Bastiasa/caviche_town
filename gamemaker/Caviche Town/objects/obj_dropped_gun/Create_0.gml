/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

gun_information = noone
timer = 0
collision_circle_radius = 0
last_touched_character = noone

function get_centre_position() {
	
	var _width = sprite_get_width(sprite_index) * gun_information.scale * .5
	var _height = sprite_get_height(sprite_index) * gun_information.scale * .5
	
	var _rotation = -phy_rotation
	
	return [
		phy_position_x + lengthdir_x(_width, _rotation) + lengthdir_x(_height, _rotation - 90),
		phy_position_y + lengthdir_y(_width, _rotation) + lengthdir_y(_height, _rotation - 90)
	]
}

function set_information(_gun_information) {
	gun_information = _gun_information
	
	image_xscale = _gun_information.scale
	image_yscale = _gun_information.scale
	
	var _fixture = physics_fixture_create()
	
	var _box_width = gun_information.physics.box_width * gun_information.scale
	var _box_height = gun_information.physics.box_height * gun_information.scale
	
	/*
	physics_fixture_set_polygon_shape(_fixture)
	
	physics_fixture_add_point(_fixture,_box_x, _box_y)
	physics_fixture_add_point(_fixture, _box_x + _box_width, _box_y)
	physics_fixture_add_point(_fixture, _box_x + _box_width, _box_y + _box_height)
	physics_fixture_add_point(_fixture, _box_x, _box_y + _box_height)
	
	*/
	
	physics_fixture_set_box_shape(_fixture, _box_width*.5, _box_height*.5)
	physics_fixture_set_friction(_fixture, gun_information.physics.friction)
	physics_fixture_set_density(_fixture, gun_information.physics.density)
	physics_fixture_set_linear_damping(_fixture, gun_information.physics.linear_damping)
	physics_fixture_set_angular_damping(_fixture, gun_information.physics.angular_damping)
	physics_fixture_set_restitution(_fixture, gun_information.physics.restitution)
	
	physics_fixture_bind(_fixture, id)
	physics_fixture_delete(_fixture)
	
	phy_active = true
}

function on_touched_by_character(_character) {
	
	if timer < 0.5 {
		return
	}
	
	var _center_position = [x,y]

	if gun_information != noone && !_character.died && _character.backpack.free_slot() != -1 && !_character.backpack.has_gun(gun_information.name) {
		
		var _free_slot = _character.backpack.free_slot()
		
		_character.backpack.put_gun(gun_information, _free_slot)
		
		if _character.equipped_gun_manager.gun_information == noone {
			_character.equipped_gun_manager.set_gun(gun_information)
		}
	
		instance_destroy(id)
		spawn_action_particle(_center_position[0], _center_position[1])
		show_debug_message("Destroyed gun and putted in "+string(_free_slot))
	} else if _character.backpack.has_gun(gun_information.name) {
	
		var _current_ammo = _character.backpack.get_ammo(gun_information.bullet_type)
		var _max_ammo = _character.backpack.get_max_ammo(gun_information.bullet_type)
		var _ammo_space = _max_ammo - _current_ammo	
		var _new_ammo = _current_ammo
		
		
	
		if _ammo_space > 0 && _ammo_space >= gun_information.loaded_ammo && _ammo_space != 0 && gun_information.loaded_ammo > 0 {
			_new_ammo = _current_ammo + gun_information.loaded_ammo
			gun_information.loaded_ammo = 0
			spawn_action_particle(_center_position[0], _center_position[1])
		} else if _ammo_space > 0 && _ammo_space < gun_information.loaded_ammo {
			gun_information.loaded_ammo -= _ammo_space
			_new_ammo = _current_ammo + _ammo_space
			spawn_action_particle(_center_position[0], _center_position[1])
		}
	
		_character.backpack.set_ammo(gun_information.bullet_type, _new_ammo)
	}
}