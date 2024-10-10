/// @description Inserte aquí la descripción
// Puede escribir su código en este editor



event_inherited()

var _pinged = false

for(var _client_index = array_length(connected_clients) - 1; _client_index > 0; _client_index--) {
	var _client = connected_clients[_client_index]
	
	if current_time - _client[1] >= ping_timeout * 1000 {
		disconnect_client(_client_index)
		continue
	}
	
	if current_time - last_clients_ping >= clients_ping_timeout * 1000 {
		send_reliable_message("connection_ping", _client)
		show_debug_message(string_concat("Pinged client: ", address_to_string(_client)))
		_pinged = true
	}
}

if _pinged {
	last_clients_ping = current_time
}

