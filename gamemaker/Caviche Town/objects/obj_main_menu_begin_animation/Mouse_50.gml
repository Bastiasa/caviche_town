/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if timer < animation_duration + buttons_animation_duration {
	timer = animation_duration + buttons_animation_duration - (delta_time / MILLION) * 2
}