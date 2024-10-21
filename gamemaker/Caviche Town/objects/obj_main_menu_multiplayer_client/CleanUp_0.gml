/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
client_socket.disconnect_from_server()
client_socket.stop_servers_searching()
client_socket.client_events.on_server_discovered.remove_listener(on_server_discovered_listener_id)