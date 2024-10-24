/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

client_socket = instance_find(obj_udp_client, 0)

on_connected_to_server = -1
on_connection_denied = -1
on_connection_failed = -1

password_length = 0
password_input = noone
address = noone

accept_button = noone
cancel_button = create_canvas_button_with_rel_size("Cancelar", .5, .55, .3, .1, layer)

cancel_button.offset_x = .5
cancel_button.offset_y = 0

function cancel_button_connect(_btn) {
	_btn.events.on_mouse_click.add_listener(function() {
		change_to_spawner(obj_main_menu_multiplayer_client, "multiplayer_client")
	})
}

cancel_button_connect(cancel_button)

function remove_socket_listeners() {
	if on_connected_to_server != -1 {
		client_socket.client_events.on_connected.remove_listener(on_connected_to_server)
		on_connected_to_server = -1
	}
	
	if on_connection_denied != -1 {
		client_socket.client_events.on_connection_denied.remove_listener(on_connection_denied)
		on_connection_denied = -1
	}
	
	if on_connection_failed != -1 {
		client_socket.client_events.on_connection_failed.remove_listener(on_connection_failed)
		on_connection_failed = -1
	}
}

function add_socket_listeners() {
	remove_socket_listeners()
	
	on_connected_to_server = client_socket.client_events.on_connected.add_listener(function() {
		change_to_spawner(obj_main_menu_multiplayer_waiting_for_start, "client_waiting_for_start")
	})
	
	on_connection_denied = client_socket.client_events.on_connection_denied.add_listener(function() {
		show_password_input()
		show_message_async("Contraseña incorrecta.")
	})
	
	on_connection_failed = client_socket.client_events.on_connection_failed.add_listener(function() {
		change_to_spawner(obj_main_menu_multiplayer_client, "multiplayer_client")
		show_message_async("Conexión fallida.")
	})
}

function show_password_input() {
	password_input = create_text_input("Contraseña", .5, .5, 0, 0, .5, .1, layer)
	accept_button = create_canvas_button_with_rel_size("Aceptar", .5, .55, .3, .1, layer)
	
	accept_button.offset_x = -0.1
	accept_button.offset_y = 0
	
	password_input.max_length = 30
	password_input.allowed_characters = ASCII_CHARS
	password_input.offset_x = .5
	password_input.offset_y = 1
	
	cancel_button.offset_x = 1.1
	cancel_button.offset_y = 0
	
	accept_button.events.on_mouse_click.add_listener(function() {
		client_socket.connect_to_server(address[0], address[1], password_input.typed_text)
		
		instance_destroy(password_input.id)
		instance_destroy(accept_button.id)
		
		password_input = noone
		accept_button = noone
		
		cancel_button.offset_x = .5
		cancel_button.offset_y = 0
	})
}

client_socket.stop_servers_searching()
client_socket.init()


function init() {
	
	add_socket_listeners()
	
	
	if password_length > 0 {
		show_password_input()
	} else {
		cancel_button.offset_x = .5
		cancel_button.offset_y = 0
	}

}