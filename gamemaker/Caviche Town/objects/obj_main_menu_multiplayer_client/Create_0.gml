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
		//show_message_async("New server discovered: "+_server_name)
	}
})

found_servers_list = instance_create_layer(0,0, layer, obj_multiplayer_found_servers_list)

found_servers_list.relative_width = .8
found_servers_list.relative_height = .65

found_servers_list.padding_x = 30
found_servers_list.padding_y = 30
found_servers_list.set_socket(client_socket)

var _count = 0

repeat 10 {
	
	_count++
	
	array_push(found_servers_list.elements, {
		server_name: "Hello world "+string(_count),
		server_address: ["localhost", 1233],
		max_clients: 5,
		clients: 3,
		password_length: 8,
		btn_hover: false,
		btn_height: 0,
		btn_x: 0,
		btn_y: 0,
		height: 0,
		y: 0
	})
}

found_servers_list.events.on_join_button_pressed.add_listener(function(_args) {
	
	var _spawner = change_to_spawner(obj_main_menu_client_connecting, "multiplayer_client_connecting", false)
	
	var _address = _args[0]
	var _password_length = _args[1]
	
	_spawner.address = _address
	_spawner.password_length = _password_length
	
	_spawner.init()
	layer_destroy_instances(layer)
})


found_servers_list.relative_position_x = .1
found_servers_list.relative_position_y = .1

found_servers_list.bg_color = c_black
found_servers_list.bg_alpha = .4

back_button = create_canvas_button_with_rel_size("Volver", .1, .8, .3, .1)

back_button.offset_x = 0
back_button.offset_y = 0

back_button.events.on_mouse_click.add_listener(function(){change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")})
