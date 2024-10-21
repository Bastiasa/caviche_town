/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

randomize()

draw_sprite_ext(
	spr_grenade,
	image_index,
	x + random_range(-shakeness, shakeness),
	y + random_range(-shakeness, shakeness),
	1,
	1,
	-phy_rotation,
	make_color_rgb(255, color_value, color_value),
	1
)

if global.debugging {
	physics_draw_debug()
}