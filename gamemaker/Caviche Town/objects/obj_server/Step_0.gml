/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _ping_time = connection_ping_time * 1000

for(var _client_index = array_length(connected_clients) - 1; _client_index > 0; _client_index--) {
	var _client = connected_clients[_client_index]
	
	if current_time - _client[1] >= _ping_time {
		array_delete(connected_clients, _client_index, 1)
		continue
	}
}