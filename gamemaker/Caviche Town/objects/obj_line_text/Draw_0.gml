/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


draw_rectangle(
	x,
	y,
	
	x+width,
	y+height,
	
	true
)

if string_length(text) < 1 {
	
	draw_set_font(fnt_current_gun_ammo)
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	draw_text_ext_color(
		
		x + padding_x,
		y + padding_y,
		
		placeholder,
		height,
		width,
		
		placeholder_color,
		placeholder_color,
		placeholder_color,
		placeholder_color,
		
		1
	)
}