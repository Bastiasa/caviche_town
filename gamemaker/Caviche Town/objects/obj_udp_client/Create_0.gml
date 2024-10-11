/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

server_address = noone
server_timeout = 10

connecting_start = -1
connecting_timeout = 10

ping = 0
send_ping_time = 3
last_sent_ping = -1
pong_received_on = -1

state = UDP_CLIENT_STATE.DISCONNECTED

client_events = {
	on_disconnected: new Event(),
	on_connected: new Event(),
	on_connection_denied: new Event()
}


function disconnect_from_server() {
	state = UDP_CLIENT_STATE.DISCONNECTED
	server_address = noone
	
	network_destroy(socket)
	socket = noone
	
	client_events.on_disconnected.fire()
}
	
function connect_to_server(_url, _port, _password = "") {
	
	show_debug_message(string_concat("Trying to connect to ",_url,":",_port,"."))
	
	init()
	
	var _address = [string_lower(_url), _port]
	var _connect_message = send_reliable_message("connection_request:"+_password, _address)
	
	if _connect_message < 1 {
		show_debug_message(string_concat("Connection request failed: ", _connect_message))
		disconnect_from_server()
		return false
	} else {
		show_debug_message("Connection request sended. Waiting for response.")
		connecting_start = current_time
		server_address = _address
		state = UDP_CLIENT_STATE.CONNECTING
		return true
	}
	
	
	
}

function is_server(_address) {
	
	if _address[0] == "localhost" {
		_address[0] = "127.0.0.1"
	}
	
	if server_address[0] == "localhost" {
		server_address[0] = "127.0.0.1"
	}
	
	return  server_address != noone && _address[0] == server_address[0] && _address[1] == server_address[1]
}

function send_ping() {
	last_sent_ping = current_time
	send_message("ping:"+string(current_time), server_address)
}

function process_message(_message, _emisor) {
	
	var _is_server = is_server(_emisor)
	
	if _is_server {
		show_debug_message("This message is from the server.")
	}

	if _message == "connection_destroyed" && _is_server {
		disconnect_from_server()
		show_debug_message("Connection destroyed by the server.")
	}
	
	if _message == "connection_stablished" && _is_server && state == UDP_CLIENT_STATE.CONNECTING {
		state = UDP_CLIENT_STATE.CONNECTED
		client_events.on_connected.fire()
		send_ping()
	}
	
	if _message == "connection_denied" && _is_server && state == UDP_CLIENT_STATE.CONNECTING {
		disconnect_from_server()
		client_events.on_connection_denied.fire()
	}
	
	if string_starts_with(_message, "pong:") && _is_server && _is_server == UDP_CLIENT_STATE.CONNECTED {
		
		var _pong_timestamp = string_delete(_message, 0, string_length("pong:"))
		_pong_timestamp = int64(_pong_timestamp)
		
		pong_received_on = current_time
		ping = current_time - (_pong_timestamp)
	}
}

