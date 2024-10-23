
relative_position_x = 0.5
relative_position_y = 0.5

width = 400
height = 300

bg_color = c_white
bg_alpha = 1

padding_x = 30
padding_y = 30

spacing = 0

var _count = 0

repeat 15 {
	_count += 1
	ds_list_add(elements, ["Hola "+string(_count), c_black])
}


function draw_element(_element, _vertical_position = 0, _index = -1) {
	
	var _text = _element[0]
	var _color = _element[1]
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(_color)
	
	draw_text(0, _vertical_position, _text)
	
	_element[1] = c_black
	
	ds_list_set(elements, _index, _element)
	
	return string_height(_text)
}

events.on_element_clicked.add_listener(function(_args) {
	show_debug_message("Clicked: "+_args[0][0])
})

events.on_element_mouse_move.add_listener(function(_args) {
	var _element = _args[0]
	var _index = _args[1]
	
	_element[1] = c_gray
	
	ds_list_set(elements, _index, _element)
})