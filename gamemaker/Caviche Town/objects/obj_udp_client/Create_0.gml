/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

show_ping = false

client_id = -1

server_address = noone
server_timeout = 20

username = ""

connecting_start = -1
connecting_timeout = 10
connected_clients = []

ping = 0
send_ping_time = 3
last_sent_ping = -1
pong_received_on = -1

state = UDP_CLIENT_STATE.DISCONNECTED

client_events = {
	on_disconnected: new Event(),
	
	on_connected: new Event(),
	on_connection_denied: new Event(),
	on_connection_failed: new Event(),
	
	on_server_discovered: new Event(),
	
	on_peer_disconnected: new Event(),
	on_peer_connected: new Event()
}

broadcasting_socket = noone

function search_servers_start() {
	
	if broadcasting_socket != noone {
		return
	}
	
	broadcasting_socket = network_create_socket_ext(network_socket_udp, UDP_BROADCASTING_PORT)
	return broadcasting_socket >= 0
}

function stop_servers_searching() {
	if broadcasting_socket != noone {
		network_destroy(broadcasting_socket)
		broadcasting_socket = noone
	}

}

function disconnect_from_server() {
	state = UDP_CLIENT_STATE.DISCONNECTED
	
	client_id = -1
	server_address = noone
	
	if socket != noone {
		network_destroy(socket)
		socket = noone
	}
	
	network_set_config(network_config_enable_multicast, true)

	
	array_delete(connected_clients, 0, array_length(connected_clients))
}
	
function connect_to_server(_url, _port, _password = "") {
	
	show_debug_message(string_concat("Trying to connect to ",_url,":",_port,"."))
	
	stop_servers_searching()
	
	var _address = [string_lower(_url), _port]
	var _username = string_length(username) > 0 ? username : "$annonymous$"
	
	send_reliable_message(string_concat(
		"connection_request,",
		_username,
		":",
		_password
	), _address)

	show_debug_message("Connection request sended. Waiting for response.")
	
	connecting_start = current_time
	pong_received_on = current_time
	
	server_address = _address
	state = UDP_CLIENT_STATE.CONNECTING
}

function is_server(_address) {
	
	if server_address == noone {
		return false
	}
	
	if _address[0] == "localhost" {
		_address[0] = "127.0.0.1"
	}
	
	if server_address[0] == "localhost" {
		server_address[0] = "127.0.0.1"
	}
	
	return  server_address != noone && _address[0] == server_address[0] && _address[1] == server_address[1]
}

function send_disconnection_message() {
	if state == UDP_CLIENT_STATE.CONNECTED {
		send_message("connection_destroy", server_address)
	}
}

function send_ping() {
	
	if server_address == noone {
		return
	}
	
	last_sent_ping = current_time
	send_message("ping,"+string(current_time), server_address)
}

function send_reliable_to_all_clients(_message) {
	
	if server_address == noone || state == UDP_CLIENT_STATE.DISCONNECTED {
		return
	}
	
	send_message(
		string_join(",",
			"resend",
			"all",
			"1"
		) + ":" + _message,
		
		server_address
	)
}

function send_to_all_clients(_message) {
	
	if server_address == noone || state == UDP_CLIENT_STATE.DISCONNECTED {
		return
	}
	
	send_message(
		string_join(",",
			"resend",
			"all",
			"0"
		) + ":" + _message,
		
		server_address
	)
}

function check_possible_server_broadcast(_message, _emisor) {
	
	var _message_data = unpack_message(_message)
	
	var _content = _message_data[0]
	var _arguments = _message_data[1]
	var _command = _arguments[0]
	
	if _command == "cts" {
		
		
		var _max_clients = number_from_string(array_pick(_arguments, 1))
		var _connected_clients_count = number_from_string(array_pick(_arguments, 2))
		var _password_length = number_from_string(array_pick(_arguments, 3))
		
		if is_nan(_max_clients) || is_nan(_connected_clients_count) || is_nan(_password_length) {
			return
		}
		
		show_debug_message("New server discovered.")
		client_events.on_server_discovered.fire([_content, _emisor, _max_clients, _connected_clients_count, _password_length])
	}
}

function handle_message(_message, _emisor) {
	
	var _message_data = unpack_message(_message)
	
	var _content = _message_data[0]
	var _arguments = _message_data[1]
	var _command = _arguments[0]
	
	var _is_server = is_server(_emisor)
	
	switch _command {
		
		case "connection_stablished":
			
			var _id = number_from_string(array_pick(_arguments, 1))
			
			if _is_server {
				if is_real(_id) {
					state = UDP_CLIENT_STATE.CONNECTED
					client_id = _id
					client_events.on_connected.fire()
				} else {
					disconnect_from_server()
					client_events.on_connection_failed.fire(["Invalid id from the server."])
				}
			}
			

			
		break
		
		case "connection_denied":
		
		if _is_server {
			disconnect_from_server()
			client_events.on_connection_denied.fire()
		}

		break
		
		case "connection_failed":
		
		if _is_server {
			disconnect_from_server()
			client_events.on_connection_failed.fire()
		}
		
		break
		
		case "client_connected":
		
		if !_is_server {
			return
		}
		
		var _client_id = number_from_string(array_pick(_arguments, 1))
		
		if is_real(_client_id) {
			array_push(connected_clients, {id:_client_id, username: _content})
			client_events.on_peer_connected.fire([_client_id])
		}
		
		break
		
		case "client_disconnected":
		
		if !_is_server {
			return
		}
		
		var _client_id = number_from_string(array_pick(_arguments, 1))
		
		if is_real(_client_id) {
			var  _index = array_get_index(connected_clients, _client_id)
			
			client_events.on_peer_disconnected.fire([_client_id])
			
			if _index != -1 {
				array_delete(connected_clients, _index, 1)
			}
		}
		
		break
		
		case "pong":
			ping = current_time - last_sent_ping
		break
			
		default:
		
		events.on_message_received.fire([_message, _emisor])
		
		break
	

	
	}
}

