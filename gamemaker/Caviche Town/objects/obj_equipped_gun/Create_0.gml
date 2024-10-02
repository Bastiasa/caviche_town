/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

gun_information = noone
character = noone

angle = 0

shooted = false
cooldown_timer = 0

function shoot() {
	if gun_information == noone {
		return
	}
	
	if cooldown_timer > 0 {
		return
	}
	
	shooted = true
	var _gun_muzzle_position = gun_information.get_muzzle_position(x,y, angle)
	
	bullet = instance_create_layer(_gun_muzzle_position.x, _gun_muzzle_position.y, "bullets", obj_equipped_gun_bullet)
	
	bullet.direction = angle
	
	bullet.initial_speed = gun_information.bullet_initial_speed
	bullet.deceleration = gun_information.bullet_deceleration
	bullet.type = gun_information.bullet_type
	bullet.scale = gun_information.bullet_scale
}