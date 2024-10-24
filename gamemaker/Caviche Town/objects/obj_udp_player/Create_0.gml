/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

client_socket = instance_find(obj_udp_client, 0)
server_socket = instance_find(obj_udp_server, 0)

client_id = 0
socket = client_socket

if client_socket.state != UDP_CLIENT_STATE.CONNECTED {
	server_socket = server_socket
}

client_id = socket.client_id

character.equipped_gun_manager.events.on_bullet_shooted.add_listener(function() {
	socket.send_reliable_to_all_clients(
		string_join(",", "shoot", client_id)
	)
})

character.events.on_grenade_throwed.add_listener(function() {
	socket.send_reliable_to_all_clients(
		string_join(",", "grenade", client_id)
	)
})