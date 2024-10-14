/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if global.debugging && global.debugging_options.show_dropped_collision_circle {
	draw_set_color(c_purple)
	draw_set_alpha(0.25)
	draw_circle(x,y, collision_circle_radius, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
}