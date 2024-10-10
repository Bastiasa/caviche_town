/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


for(var _client_index = array_length(connected_clients) - 1; _client_index > 0; _client_index--) {
	var _client = connected_clients[_client_index]
	
	if current_time - _client[1] >= ping_timeout * 1000 {
		disconnect_client(_client_index)
		continue
	}
}


event_inherited()