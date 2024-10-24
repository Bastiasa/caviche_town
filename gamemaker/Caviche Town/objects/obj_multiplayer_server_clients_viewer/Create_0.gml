/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
event_inherited()

socket = noone

on_connected_id = -1
on_disconnected_id = -1

function remove_socket_listeners() {
	if socket != noone && on_connected_id != -1 && on_disconnected_id != -1 {
	
		socket.server_events.on_client_connected.remove_listener(on_connected_id)
		socket.server_events.on_client_disconnected.remove_listener(on_disconnected_id)
		
		on_connected_id = -1
		on_disconnected_id = -1
	}
}

function set_socket(_socket) {
	
	remove_socket_listeners()
	
	socket = _socket
	
	on_connected_id = _socket.server_events.on_client_connected.add_listener(function(_args) {
		var _client = _args[0]
		
		var _id = _client[2]		
		var _username = _client[3]
		
		var _complete_username = string_concat(_username, "#", _id)
		
		array_push(elements, {
			client: _client,
			username: _complete_username,
			id:_id
		})
	})
	
	on_disconnected_id = _socket.server_events.on_client_disconnected.add_listener(function(_args) {
		var _client = _args[0]
		
		for(var _index = 0; _index < array_length(elements); _index++) {
			var _element = array_get(elements, _index)
			
			if _element.id == _client[2] {
				array_delete(elements, _index, 1)
				break
			}
		}
	})
}



padding_x = 50
padding_y = 50

function draw_element(_element_data, _element_y, _element_index) {
	var _username = _element_data.username
	var _height = string_height(_username)
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	
	draw_text(
		0,
		_element_y,
		_username
	)
	
	var _render_width = get_render_width()
	var _button_left = _render_width * .75
	var _button_bottom = _element_y + _height
	var _button_width = _render_width * .25 - padding_x
	
	draw_set_color(c_red)
	draw_set_alpha(0.87)
	
	draw_roundrect(
		_button_left,
		_element_y,
		_button_left + _button_width,
		_button_bottom,
		
		false
	)
	
	draw_set_color(c_white)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	draw_text(
		_button_left + _button_width * .5,
		_element_y + _height * .5,
		"Expulsar"
	)
	
	return _height
}