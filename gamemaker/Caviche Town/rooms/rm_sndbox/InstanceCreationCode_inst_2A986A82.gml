
relative_position_x = 0.5
relative_position_y = 0.5

width = 400
height = 300

bg_color = c_white
bg_alpha = 1

padding_x = 30
padding_y = 30

spacing = 0

var _count = 1

repeat 15 {
	_count += 1
	ds_list_add(elements, "Hola "+string(_count))
}


function draw_element(_element, _vertical_position = 0) {
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	draw_text(0, _vertical_position, _element)
	return string_height(_element) + _vertical_position
}