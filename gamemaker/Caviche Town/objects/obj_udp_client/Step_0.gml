/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

if state == UDP_CLIENT_STATE.CONNECTED && current_time - connected_server_last_ping >= server_timeout * 100 {
	disconnect_from_server()
}

if state == UDP_CLIENT_STATE.CONNECTING && current_time - connecting_start >= connecting_timeout * 1000 {
	show_debug_message("Connecting time is out.")
	disconnect_from_server()
}

