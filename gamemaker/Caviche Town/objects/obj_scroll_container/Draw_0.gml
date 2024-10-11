/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

if !surface_exists(children_surface) {
	children_surface = create_surface()
}


draw_surface_ext(
	children_surface,
	x,
	y,
	scale_x,
	scale_y,
	rotation,
	c_white,
	alpha
)

