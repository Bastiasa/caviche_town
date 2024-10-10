/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

server = -1
password = ""

connection_ping_time = 60

connected_clients = []

function init(_port = 303, _max_clients = 32) {
	server = network_create_server(network_socket_tcp, _port, _max_clients)

	if server < 0 {
		show_debug_message("Error while creating server.")
	} else {
		show_debug_message("Server created successfully.")
	}
}

function get_client_index_by_address(_address) {
	var _result = -1
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		
		if _client[?0] == _address[?0] && _client[?1] == _address[?1] {
			_result = _client_index
			break
		}
	}
	
	return _result
}

function send_to_all_clients(_message) {
	
	if !is_string(_message) {
		return false
	}
	
	if server < 0 {
		return false
	}
	
	var _message_length = string_length(_message)
	var _buffer = buffer_create(_message_length, buffer_grow, 1)
	buffer_write(_buffer, buffer_string, _message)
	
	var _failures = []
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		
		var _send_result = network_send_udp(server, _client[0][0], _client[0][1], _buffer, _message_length)
		
		if !_send_result {
			array_push(_failures, _client)
		}
	}
	
	buffer_delete(_buffer)
	return _failures
}

function process_message(_message, _emisor) {
	if string_starts_with(_message, "connection_request:")  {
		var _password = string_split(_message, "connection_request:", true, 1)[?0]
		
		if _password == password {	
			array_push(connected_clients, [_emisor, current_time])
			return true
		}
	}

	if string_starts_with(_message, "connection_destroy")  {
		var _client_index = get_client_index_by_address(_emisor)
		var _client = connected_clients[?_client_index]
		
		if _client != undefined {
			disconnect_client(_client)
		}
	}
	
	if string_starts_with(_message, "connection_ping") {
		var _client_index = get_client_index_by_address(_emisor)
		var _client = connected_clients[?_client_index]
		
		if _client != undefined {
			_client[1] = current_time
			return true
		}
	}
	
	if string_starts_with(_message, "send_all:") {
		var _to_send = string_split(_message, "send_all:", true, 1)[?0]
		
		if string_length(_to_send) > 0 {
			send_to_all_clients(_to_send)
			return true
		}
	}

}

events = {
	on_message_received: new Event(),
	on_client_connected: new Event(),
	on_client_disconnected: new Event(),
	on_connection_error: new Event()
}