/// @description Inserte aquí la descripción
// Puede escribir su código en este editor



event_inherited()

var _pinged = false

for(var _client_index = array_length(connected_clients) - 1; _client_index > 0; _client_index--) {
	var _client = connected_clients[_client_index]
	
	if current_time - _client[1] >= ping_timeout * 1000 {
		disconnect_client(_client_index)
		show_debug_message("Client disconnected for inactivity: "+address_to_string(_client))
		continue
	}
}

if _pinged {
	last_clients_ping = current_time
}

