/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
event_inherited()


socket = noone


on_server_discovered_id = -1

function set_socket(_socket) {

	socket = _socket
	
	on_server_discovered_id = socket.client_events.on_server_discovered.add_listener(function(_args) {
		var _server_name, _server_address, _max_clients, _connected_clients_count, _password_length
		
		_server_name = _args[0]
		_server_address = _args[1]
		_max_clients = _args[2]
		_connected_clients_count = _args[3]
		_password_length = _args[4]
		
		for(var _index = 0; _index < ds_list_size(elements); _index = 0) {
			
		}
		
		ds_list_add(
			elements,
			{
				server_name:_server_name,
				server_address: _server_address,
				max_clients: _max_clients,
				clients: _connected_clients_count,
				password_length: _password_length
			}
		)
		
	})
}