/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

connected_server_address = noone
connected_server_last_ping = -1

connecting_start = -1
connecting_timeout = 10

server_timeout = 24*2

last_ping_time = -1
ping_time = 5

state = UDP_CLIENT_STATE.DISCONNECTED

client_events = {
	on_disconnected: new Event(),
	on_connected: new Event(),
	on_connection_denied: new Event()
}


function disconnect_from_server() {
	state = UDP_CLIENT_STATE.DISCONNECTED
	connected_server_address = noone
	connected_server_last_ping = -1
	
	network_destroy(socket)
	socket = noone
	
	client_events.on_disconnected.fire()
}
	
function connect_to_server(_url, _port, _password = "") {
	
	show_debug_message(string_concat("Trying to connect to ",_url,":",_port,"."))
	
	if init() {
		network_connect_raw(socket, _url, _port)
	}
	

	
	var _address = [_url, _port]
	var _connect_message = send_reliable_message("connection_request:"+_password, _address)
	
	if _connect_message < 1 {
		show_debug_message(string_concat("Connection request failed: ", _connect_message))
		disconnect_from_server()
		return false
	} else {
		show_debug_message("Connection request sended. Waiting for response.")
		connecting_start = current_time
		connected_server_address = _address
		state = UDP_CLIENT_STATE.CONNECTING
		return true
	}
	
	
	
}

function is_server(_address) {
	return socket != noone && connected_server_address != noone && _address[0] == connected_server_address[0] && _address[1] == connected_server_address[1]
}

function process_message(_message, _emisor) {
	
	show_debug_message("Message received from "+address_to_string(_emisor))
	
	var _is_server = is_server(_emisor)
	
	if _message == "connection_destroyed" && _is_server {
		disconnect_from_server()
	}
	
	if _message == "connection_stablished" && _is_server && state == UDP_CLIENT_STATE.CONNECTING {
		connected_server_last_ping = current_time
		state = UDP_CLIENT_STATE.CONNECTED
		client_events.on_connected.fire()
	}
	
	if _message == "connection_denied" && _is_server && state == UDP_CLIENT_STATE.CONNECTING {
		disconnect_from_server()
		client_events.on_connection_denied.fire()
	}
	
	if _message == "connection_ping" && _is_server && _is_server == UDP_CLIENT_STATE.CONNECTED {
		connected_server_last_ping = current_time
	}
}

