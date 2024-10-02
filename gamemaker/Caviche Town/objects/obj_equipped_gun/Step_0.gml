/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _delta = delta_time / MILLION

if shooted {
	cooldown_timer += _delta
	
	
	if cooldown_timer >= gun_information.cooldown_end {
		shooted = false
		cooldown_timer = 0
	}
}