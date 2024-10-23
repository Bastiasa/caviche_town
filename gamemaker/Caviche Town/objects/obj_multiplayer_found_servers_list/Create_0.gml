/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
event_inherited()


socket = noone

on_server_discovered_id = -1

padding_x = 200

events.on_join_button_pressed = new Event()

function find_server_index_by_address(_address) {
	
	var _result = -1

	for(var _index = 0; _index < array_length(elements); _index = 0) {
		var _found_server_information = array_get(elements, _index)
			
		if addres_compare(_found_server_information.server_address, _address) {				
			_result = _index
			break
		}
	}
	
	return _result
}

function remove_listeners() {
	if socket == noone {
		return
	}
	
	if on_server_discovered_id == -1 {
		return
	}
	
	socket.client_events.on_server_discovered.remove_listener(on_server_discovered_id)
}

function set_socket(_socket) {
	
	remove_listeners()

	socket = _socket
	
	if socket == noone {
		return
	}
	
	on_server_discovered_id = socket.client_events.on_server_discovered.add_listener(function(_args) {
		var _server_name, _server_address, _max_clients, _connected_clients_count, _password_length

		_server_name = _args[0]
		_server_address = _args[1]
		_max_clients = _args[2]
		_connected_clients_count = _args[3]
		_password_length = _args[4]
		
		show_debug_message("Cock "+string(struct_get_names(socket.client_events.on_server_discovered.listeners)))
		
		var _found_server_information_index = find_server_index_by_address(_server_address)
		
		if _found_server_information_index != -1 {
			var _found_server_information = elements[_found_server_information_index]
			
			_found_server_information.server_name = _server_name
			_found_server_information.max_clients = _max_clients
			_found_server_information.clients = _connected_clients_count
			_found_server_information.password_length = _password_length
			
		} else {
			array_push(
				elements,
				
				{
					server_name:_server_name,
					server_address: _server_address,
					max_clients: _max_clients,
					clients: _connected_clients_count,
					password_length: _password_length,
					btn_hover: false,
					btn_x: 0,
					btn_y: 0,
					btn_height: 0,
					height: 0,
					y: 0
				}
			)
		}
	})
}

events.on_element_mouse_move.add_listener(function(_args) {
	var _element_data = _args[0]
	var _element_index = _args[1]
	
	var _mouse_x = _args[2]
	var _mouse_y = _args[3] - _element_data.y
	
	var _in_x = _mouse_x >= _element_data.btn_x && _mouse_x < _element_data.btn_x + get_render_width() * .25 - padding_x * .5
	var _in_y = _mouse_y >= 0 && _mouse_y < _element_data.btn_height
	
	_element_data.btn_hover = _in_x && _in_y
})

events.on_element_clicked.add_listener(function(_args) {
	var _element_data = _args[0]
	
	if _element_data.btn_hover {
		events.on_join_button_pressed.fire([_element_data.server_address, _element_data.password_length])
	}
})


function draw_element(_element_data, _vertical_position, _element_index) {
	
	draw_set_color(c_white)
	draw_set_font(font)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_alpha(1)
	
	var _text = string_concat(_element_data.server_name, "\n", _element_data.max_clients, "/", _element_data.clients)
	var _text_height = string_height(_text)
	var _render_width = get_render_width()
	
	draw_text(0, _vertical_position, _text)
	
	var _button_hover = _element_data.btn_hover
	
	draw_set_color(_button_hover ? make_color_rgb(0, 255, 0) : make_color_rgb(0, 200, 0))
	draw_set_alpha(_button_hover ? .8 : .6)
	
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	var _join_button_x = _render_width * .75
	var _join_button_y = _vertical_position
	
	var _join_button_width = _render_width * .25
	var _join_button_height = _text_height
	
	draw_roundrect(
		_join_button_x,
		_join_button_y,
		_render_width - padding_x,
		_vertical_position + _text_height,
		false
	)
	
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	draw_text(	
		_join_button_x + _join_button_width * .5 - padding_x * .5,
		_join_button_y + _join_button_height * .5,
		"Unirse"
	)
	
	var _line_padding = padding_y
	var _line_count = 3
	
	if _element_index < array_length(elements) - 1 {
		draw_set_color(c_white)
		draw_set_alpha(1)
		
		var _bottom = _text_height + _vertical_position
		var _line_num = -1
		
		
		repeat _line_count {
			_line_num++
			
			var _line_bottom = _bottom + _line_num + _line_padding
			draw_line(0, _line_bottom, _render_width, _line_bottom)
		}

	} else {
		_line_count = 0
		_line_padding = 0
	}
	
	_element_data.btn_hover = false
	_element_data.height = _text_height
	_element_data.y = _vertical_position
	_element_data.btn_x = _join_button_x
	_element_data.btn_y = _join_button_y
	_element_data.btn_height = _join_button_height
	
	return _text_height + _line_count + _line_padding
}