/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

server_socket.events.on_message_received.remove_listener(on_server_message_received)
client_socket.events.on_message_received.remove_listener(on_client_message_received)
server_socket.server_events.on_client_disconnected.remove_listener(on_client_disconnected)
client_socket.client_events.on_peer_disconnected.remove_listener(on_peer_disconnected)