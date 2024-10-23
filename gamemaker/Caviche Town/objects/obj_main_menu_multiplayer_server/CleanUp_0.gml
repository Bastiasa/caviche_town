/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

server_socket.broadcasting = false

var _last_server_data = {
	max_clients: server_socket.max_clients,
	name: server_socket.server_name,
	password: server_socket.password
}

save_value("server_creation_last_data" , _last_server_data)