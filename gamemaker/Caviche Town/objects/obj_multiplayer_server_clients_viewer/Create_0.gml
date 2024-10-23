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
	
	on_connected_id = _socket.server_events.on_client_connected.add_listener(function(_client_info) {
		var _id = _client_info[2]		
		var _username = _client_info[3]
		
		var _complete_username = string_concat(_username, "#", _id)
		
		ds_list_add(elements, {
			client: _client_info,
			username: _complete_username,
			kick_button_color: c_white,
			kick_button_text_color: c_black,
			id:_id
		})
	})
	
	on_disconnected_id = _socket.server_events.on_client_disconnected.add_listener(function(_client_info) {
		for(var _index = 0; _index < ds_list_size(elements); _index++) {
			var _element = ds_list_find_value(elements, _index)
			
			if _element.id == _client_info[2] {
				ds_list_delete(elements, _index)
				break
			}
		}
	})
}

function draw_element(_element_data, _element_y, _element_index) {
	var _username = _element_data.username
}