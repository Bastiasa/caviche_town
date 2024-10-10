/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

server = -1

connected_peers = []

function init(_port = 303, _max_clients = 32) {
	server = network_create_server(network_socket_tcp, _port, _max_clients)

	if server < 0 {
		show_debug_message("Error while creating server.")
	} else {
		show_debug_message("Server created successfully.")
	}
}

function process_message(_message, _emisor) {

}

events = {
	on_message_received: new Event(),
	on_client_connected: new Event(),
	on_client_disconnected: new Event(),
	on_connection_error: new Event()
}