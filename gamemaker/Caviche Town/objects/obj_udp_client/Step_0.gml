/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

if state == UDP_CLIENT_STATE.CONNECTED && current_time - pong_received_on >= server_timeout * 1000 {
	show_debug_message("The server has not been active. Disconnected.")
	disconnect_from_server()
}

if state == UDP_CLIENT_STATE.CONNECTED && current_time - last_sent_ping >= send_ping_time * 1000 {
	send_ping()
}

if state == UDP_CLIENT_STATE.CONNECTING && current_time - connecting_start >= connecting_timeout * 1000 {
	show_debug_message("Connecting time is out.")
	disconnect_from_server()
	client_events.on_connection_failed.fire()
}

