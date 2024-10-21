/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

client_socket = instance_find(obj_udp_client, 0)
client_socket.search_servers_start()

discovered_servers = []

on_server_discovered_listener_id = client_socket.client_events.on_server_discovered.add_listener(function(_args) {
	var _server_name = _args[0]
	var _server_address = _args[1]
	
	var _found = -1
	
	for(var _index = 0; _index < array_length(discovered_servers); _index++) { 
		var _discovered_server = discovered_servers[_index]
		var _discovered_server_address = _discovered_server[1]
		
		if client_socket.address_to_string(_discovered_server_address) == client_socket.address_to_string(_server_address) {
			_found = _index
			_discovered_server[0] = _server_name
			break
		}
	}
	
	if _found == -1 {
		array_push(discovered_servers, [_server_name, _server_address])
		show_message_async("New server discovered: "+_server_name)
	}
})

back_button = create_canvas_button("Volver", .5, .5, 300, 100)

back_button.offset_x = .5
back_button.offset_y = .5

back_button.events.on_mouse_click.add_listener(function(){change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")})
