/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


event_inherited()

password = ""

ping_timeout = 60
connected_clients = []

server_options = {
	max_clients:32
}



function init(_port = 6060, _max_clients = 32) {
	socket = network_create_socket_ext(network_socket_udp, _port)

	if socket < 0 {
		show_debug_message("Error while creating server.")
	} else {
		server_options.max_clients = _max_clients
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

function connect_client(_address) {
	var _client = [_emisor, current_time]
	array_push(connected_clients, _client)
	events.on_client_connected.fire([_client])
	
	send_reliable_message("connection_successfully", _address)
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

function generate_message_id(_message, _address) {
	reliable.next_id++
	
	var _id = reliable.next_id
	var _content = string_concat("reliable#",_id,":",_message)

	var _info = {address:_address, content:_content, id:_id, start_time: current_time}
	
	array_push(reliable.messages, _info)
	return _info
}




function process_message(_message, _emisor) {
	
	show_message("Someone sent a message :0")
	
	if string_starts_with(_message, "connection_request:")  {
		var _password = string_split(_message, "connection_request:", true, 1)[?0]
		
		if _password == password {	
			connect_client(_emisor)
			return true
		}
	}
	
	if string_starts_with(_message, "reliable_received#") {
		var _reliable = string_split(_message, "reliable_received#", true, 1)[?0]
		
		if _reliable != undefined {
			var _reliable_message_id = string_digits(_reliable)
			_reliable_message_id = int64(_reliable_message_id)
			
			remove_reliable_message(_reliable_message_id)
		}
	}

	if string_starts_with(_message, "connection_destroy")  {
		var _client_index = get_client_index_by_address(_emisor)
		disconnect_client(_client_index)
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
			send_to_all_clients(_to_send, _emisor)
			return true
		}
	}

}

events = {
	on_message_received: new Event(),
	on_client_connected: new Event()
}