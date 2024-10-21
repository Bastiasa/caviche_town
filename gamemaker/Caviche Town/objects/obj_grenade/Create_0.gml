/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

image_speed = 0
image_index = 1

start_x = x
start_y = y

owner = noone
timer = 0
explosion_time = 3

shakeness = 0
color_value = 255


time = current_time
destroyed = false

events = {
	on_exploded: new Event()
}

function impulse(_x,_y,_ximpulse,_yimpulse) {
	physics_apply_impulse(_x,_y,_ximpulse,_yimpulse)
}



function explode() {
	
	if destroyed {
		return
	}
	
	destroyed = true
	
	var _explosion = create_explosion(
		phy_position_x,
		phy_position_y,
		layer,
		128,
		100,
		1/3,
		owner
	)
	
	events.on_exploded.fire([_explosion])
	
	_explosion.player_shakeness = 5
	_explosion.init()
	
	timer = 0
	
	show_debug_message("Recorrido: "+string(x - start_x))
	show_debug_message("Tiempo: "+string((current_time - time)/1000))
	instance_destroy(id)
}
