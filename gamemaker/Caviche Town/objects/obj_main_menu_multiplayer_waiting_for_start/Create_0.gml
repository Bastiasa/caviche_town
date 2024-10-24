/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

client_socket = instance_find(obj_udp_client, 0)

back_button = create_canvas_button_with_rel_size("Salir", .5, .9, .5, .1, layer)

back_button.offset_x = .5
back_button.offset_y = 1

on_disconnected_id = -1

function remove_listeners() {
	if on_disconnected_id != -1 {
		client_socket.client_events.on_disconnected.remove_listener(on_disconnected_id)
		on_disconnected_id = -1
	}
}

client_socket.client_events.on_disconnected.add_listener(function() {
	show_message_async("Se perdió la conexión.")
	change_to_spawner(obj_main_menu_multiplayer_client, "multiplayer_client")
})

back_button.events.on_mouse_click.add_listener(function () {
	client_socket.send_disconnection_message()
	client_socket.disconnect_from_server()
	change_to_spawner(obj_main_menu_multiplayer_client, "multiplayer_client")
})