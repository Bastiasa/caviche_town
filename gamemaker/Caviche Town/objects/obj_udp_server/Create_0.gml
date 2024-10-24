/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


event_inherited()

server_name = "Sin nombre"
password = ""

broadcasting = true
broadcast_duration = 2
last_broadcast = 0


client_timeout = 20
connected_clients = []

last_clients_ping = -1
clients_ping_timeout = 24

next_client_id = 0

max_clients = 4
port = -1

server_events = {
	on_message_received: new Event(),
	on_client_connected: new Event(),
	on_client_disconnected: new Event()
}


function destroy() {
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		send_message("connection_destroyed", _client)
	}
	
	connected_clients = []
	last_clients_ping = -1
	network_destroy(socket)
	socket = noone
	port = -1
}

/*function init(_port = 6060, _max_clients = 32) {
	socket = network_create_socket_ext(network_socket_udp, _port)
	
	if socket < 0 {
		show_debug_message("Error while creating server.")
		last_clients_ping = -1
	} else {
		server_options.max_clients = _max_clients
		show_debug_message(string_concat("UDP server created successfully. Running on port ",_port, " and maximum clients of ", _max_clients))
	}
}*/


function init() {
	
	randomize()
	
	port = irandom(6000)
	socket = network_create_socket_ext(network_socket_udp, port)
	
	while socket < 0 {
		randomize()
		port = irandom(6000)
		socket = network_create_socket_ext(network_socket_udp, port)
	}
	
	return port
}

function get_client_index_by_address(_address) {
	var _result = -1
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		var _client_address = _client[0]
		
		if _client_address[0] == _address[0] && _client_address[1] == _address[1] {
			_result = _client_index
			break
		}
	}
	
	return _result
}

function get_client_index_by_id(_id) {
	var _result = -1
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client]
		var _client_id = _client[2]
		
		if _client_id == _id {
			_result = _client_id
			break
		}
	}
	
	return _result
}

function stablish_client_connection(_address, _username) {
	
	if array_length(_address) < 2 || !is_string(_address[0]) || !is_numeric(_address[1]) {
		return
	}
	
	next_client_id++
	
	
	var _client_id = next_client_id
	var _client = [_address, current_time, _client_id, _username]
	array_push(connected_clients, _client)
	server_events.on_client_connected.fire([_client])
	
	var _other_clients_advice = "client_connected,"+string(_client_id)
	
	send_reliable_message("connection_stablished,"+string(_client_id), _address)
	send_reliable_to_all_clients(_other_clients_advice, [_client])
}

function disconnect_client(_index) {
	
	if _index < 0 {
		return
	}
	
	var _client = array_pick(connected_clients, _index)
	
	if _client != undefined {
		
		
		array_delete(connected_clients, _index, 1)
		server_events.on_client_disconnected.fire([_client])
		
		var _client_address = _client[0]
		var _client_id = _client[2]
		
		send_reliable_message("connection_destroyed", _client_address)
		send_reliable_to_all_clients("client_disconnected,"+string_concat(_client_id), [_client])
	}
}

function send_reliable_to_all_clients(_message, _except = []) {

	
	if !is_string(_message) {
		return false
	}
	
	if socket == noone || socket < 0 {
		return false
	}
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		
		var _client = connected_clients[_client_index]
		
		if array_contains(_except, _client) {
			continue
		}
		
		var _client_address = _client[0]
		send_reliable_message(_message, _client_address) //network_send_udp_raw(server, _client[0][0], _client[0][1], _buffer, _message_length)
	}
}

function send_to_all_clients(_message, _except = []) {

	
	if !is_string(_message) {
		return false
	}
	
	if socket == noone || socket < 0 {
		return false
	}
	
	var _message_length = string_length(_message)
	var _buffer = buffer_create(_message_length, buffer_grow, 1)
	buffer_write(_buffer, buffer_text, _message)
	
	var _failures = []
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		
		if array_contains(_except, _client) {
			continue
		}
		
		var _client_address = _client[0]
		
		var _send_result = send_buffer(_buffer, _client_address, false) //network_send_udp_raw(server, _client[0][0], _client[0][1], _buffer, _message_length)
		
		if !_send_result {
			array_push(_failures, _client)
		}
	}
	
	buffer_delete(_buffer)
	return _failures
}

function handle_message(_message, _emisor) {
	
	var _message_data = unpack_message(_message)
	
	var _content = _message_data[0]
	var _arguments = _message_data[1]
	var _command = _arguments[0]
	
	var _string_emisor = address_to_string(_emisor)
	var _found_client_index = get_client_index_by_address(_emisor)
	var _is_client = _found_client_index != -1
	
	if _is_client {
		var _client = connected_clients[_found_client_index]
		_client[1] = current_time
	}
	
	switch _command {
		
		case "connection_request":
		
		var _username = array_pick(_arguments, 1)
		
		if array_length(connected_clients) >= max_clients {
			send_reliable_message("connection_failed", _emisor)
			show_debug_message("Connection failed with "+address_to_string(_emisor))
			return
		}
			
		if !is_string(_username) || _content != password {
			send_reliable_message("connection_denied", _emisor)
			show_debug_message("Connection denied with "+address_to_string(_emisor))
			return
		}
			
		stablish_client_connection(_emisor, _username);
		show_debug_message("Connection stablished with "+address_to_string(_emisor))
		break
		
		case "resend":
		
		if !_is_client {
			return
		}
		
		var _destination = array_pick(_arguments, 1)
		var _reliable = array_pick(_arguments, 2) == "1"
		
		if _resend_content == undefined {
			return
		}
		
		if _destination != "all" || string_length(_destination) == 0 {
			return
		} else if _destination != "all" {
			_destination = number_from_string(_destination)
			
			if !is_real(_destination) {
				return
			}
		}
		
		
		
		if is_real(_destination) {
			
			var _client_index = get_client_index_by_id(_destination)
			var _client = array_pick(connected_clients, _client_index)
			
			if _client != undefined {
				var _client_address = _client[0]
				
				if _reliable {
					send_reliable_message(_content, _client_address)
				}
			} else if _destination == 0 {
				process_message(_content, _emisor)
			}
			
			
		} else if _destination == "all" {
			if _reliable {
				send_reliable_to_all_clients(_content)
			} else {
				send_to_all_clients(_content)
			}
			
			process_message(_content, _emisor)
		}
		
		
		break
		
		case "connection_destroy":
		
		if _is_client {
			var _client = array_pick(connected_clients, _found_client_index)
				
			if _client != undefined {
				disconnect_client(_client)
			}
		}
			
		break
		
		case "ping":
		
		var _current_time_ = array_pick(_arguments, 1)
		send_message(string_concat("pong,", _current_time_), _emisor)
		
		break
		
		default:
		
		events.on_message_received.fire([_message, _arguments])
		
		break
	}

}

