/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


event_inherited()

password = ""

ping_timeout = 60
connected_clients = []

last_clients_ping = -1
clients_ping_timeout = 24

server_options = {
	max_clients:32
}


function destroy() {
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		send_reliable_message("connection_destroyed", _client)
	}
	
	connected_clients = []
	last_clients_ping = -1
	network_destroy(socket)
	socket = noone
}

function init(_port = 6060, _max_clients = 32) {
	socket = network_create_socket_ext(network_socket_udp, _port)
	
	if socket < 0 {
		show_debug_message("Error while creating server.")
		last_clients_ping = -1
	} else {
		server_options.max_clients = _max_clients
		last_clients_ping = current_time
		show_debug_message(string_concat("UDP server created successfully. Running on port ",_port, " and maximum clients of ", _max_clients))
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

function connect_client(_address) {
	var _client = [_emisor, current_time]
	array_push(connected_clients, _client)
	events.on_client_connected.fire([_client])
	
	send_reliable_message("connection_stablished", _address)
	send_to_all_clients("client_connected:"+string_concat(_address[0],":",_address[1]), "server")
}

function disconnect_client(_index) {
	
	if _index < 0 {
		return
	}
	
	var _client = connected_clients[?_index]
	
	if _client != undefined {
		array_delete(connected_clients, _index, 1)
		events.on_client_connected.fire([_client])
		send_reliable_message("connection_destroyed", _client)
		send_to_all_clients("client_disconnected:"+string_concat(_address[0],":",_address[1]), "server")
	}
}


function send_to_all_clients(_message, _address) {
	
	var _client_index = -1
	
	if is_array(_address) {
		_client_index = get_client_index_by_address(_address)
	} else if is_string(_address) && _address == "server" {
		_client_index = 999
	}
	
	if _client_index == -1 {
		return false
	}
	
	if !is_string(_message) {
		return false
	}
	
	if socket < 0 {
		return false
	}
	
	var _message_length = string_length(_message)
	var _buffer = buffer_create(_message_length, buffer_grow, 1)
	buffer_write(_buffer, buffer_string, _message)
	
	var _failures = []
	
	for(var _client_index = 0; _client_index < array_length(connected_clients); _client_index++) {
		var _client = connected_clients[_client_index]
		
		var _send_result = send_buffer(_buffer, _client, false) //network_send_udp_raw(server, _client[0][0], _client[0][1], _buffer, _message_length)
		
		if !_send_result {
			array_push(_failures, _client)
		}
	}
	
	buffer_delete(_buffer)
	return _failures
}


function process_message(_message, _emisor) {
	
	show_message("Someone sent a message")
	
	var _connected_clients_count = array_length(connected_clients)
	var _checking_commmand = ""
	
	
	function remove_message_preffix(_message, _preffix) {
		return string_delete(_message, 0, string_length(_preffix))
	}
	
	
	_checking_commmand = "connection_request:"
	if string_starts_with(_message, _checking_commmand) && _connected_clients_count < server_options.max_clients  {
		var _password = remove_message_preffix(_message, _checking_commmand)
		
		if _password == password {	
			connect_client(_emisor)
			show_debug_message(string_concat("Client connected: ",address_to_string(_emisor)))
			return true
		} else {
			send_reliable_message("connection_denied", _emisor)
		}
	} else if _connected_clients_count >= server_options.max_clients {
		send_reliable_message("connection_denied", _emisor)
	}
	
	_checking_commmand = "connection_destroy"
	if _message == _checking_commmand  {
		var _client_index = get_client_index_by_address(_emisor)
		disconnect_client(_client_index)
		
		show_debug_message(string_concat("Client disconnected: ",address_to_string(_emisor)))
	}
	
	
	
	_checking_commmand = "connection_ping"
	if _message = _checking_commmand {
		var _client_index = get_client_index_by_address(_emisor)
		var _client = connected_clients[?_client_index]
		
		if _client != undefined {
			_client[1] = current_time
			return true
		}
	}
	
	
	_checking_commmand = "everyone:"
	if string_starts_with(_message, _checking_commmand) {
		var _to_send = remove_message_preffix(_message,_checking_commmand)
		
		if string_length(_to_send) > 0 {
			send_to_all_clients(_to_send, _emisor)
			return true
		}
	}

}

events = {
	on_message_received: new Event(),
	on_client_connected: new Event()
}