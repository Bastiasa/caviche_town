/// @description Inserte aquí la descripción
// Puede escribir su código en este editor



event_inherited()

if current_time - last_broadcast >= broadcast_duration*1000 && socket != noone && socket >= 0 && broadcasting { 
	last_broadcast = current_time
	
	var _broadcast_content = "cts:"+server_name
	var _broadcast_content_length = string_length(_broadcast_content)
	
	var _buffer = buffer_create(_broadcast_content_length, buffer_grow, 1)
	
	buffer_write(_buffer, buffer_text, _broadcast_content)
	
	var _result = network_send_broadcast(
		socket,
		UDP_BROADCASTING_PORT,
		_buffer,
		buffer_tell(_buffer)
	)
	
	buffer_delete(_buffer)
}


for(var _client_index = array_length(connected_clients) - 1; _client_index >= 0; _client_index--) {
	var _client = connected_clients[_client_index]
	var _client_address = _client[0]
	var _client_last_message = _client[1]
	
	if current_time - _client_last_message >= client_timeout * 1000 {
		disconnect_client(_client_index)
		show_debug_message("Client disconnected for inactivity: "+address_to_string(_client_address))
		break
	}
}
