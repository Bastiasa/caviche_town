/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

timer += delta_time / MILLION

var _explosion_completed_percent = timer / explosion_time

shakeness = 2 * _explosion_completed_percent
color_value = 255 * (1 -_explosion_completed_percent)

if timer >= explosion_time {
	explode()
}