/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if type == BULLET_TYPE.ROCKET {
	
	var _explosion = create_explosion(
		x,
		y,
		layer,
		128,
		damage,
		0.4,
		shooter
	)
	
	_explosion.events.on_character_hitted.add_listeners(events.on_character_hitted.listeners)
	_explosion.init()
	
}