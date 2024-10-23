/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

reliable_server = noone
unreliable_server = noone

tcp_port = -1
udp_port = -1

max_clients = 5
next_client_id = -1

clients = []

on_message_received = new Event()

function unpack_message(_message) {
	
	var _result = []
	var _has_arguments = false
	var _content_start = string_pos(":", _message)

	var _parts = string_split(_message, ":", false, 1)
	var _content = array_length(_parts) > 1 ? _parts[1] : ""
	var _message_begin_part = _parts[0]
		
	_has_arguments = string_pos(",", _message_begin_part) != 0
		
	if _has_arguments {
		var _arguments = string_split(_message_begin_part, ",", false)
			
		_result[0] = _content
		_result[1] = _arguments
	} else {
		_result[0] = _content
		_result[1] = [_message_begin_part]
	}
	
	return _result
}

function find_client(_socket) {
	var _found_index = -1
	
	for(var _index = 0; _index < array_length(clients); _index++) {
		var _client_data = clients[_index]
		
		if _client_data.tcp_socket == _socket {
			_found_index = _index
			break
		}
	}
	
	return _found_index
}



function remove_client(_socket) {
	var _found_index = find_client(_socket)
	
	if _found_index != -1 {
		array_delete(clients, _found_index, 1)
	}
}

function append_client(_socket) {
	next_client_id++
	
	var _client_id = next_client_id
	var _client_data = {
		id: _client_id,
		tcp_socket: _socket,
		last_activity: current_time
	}
	
	array_push(clients, _client_data)
}

function create_server_with_random_port(_type) {
	var _port = irandom(6000)
	var _result = -1
	
	while _result < 0 {
		_port = irandom(6000)
		_result = network_create_server(_type, _port, 32)
	}
	
	return [_result, _port]
}

function init() {
	
	var _tcp_server_result = create_server_with_random_port(network_socket_tcp)
	var _udp_server_result = create_server_with_random_port(network_socket_udp)
	
	reliable_server = _tcp_server_result[0]
	unreliable_server = _udp_server_result[0]
	
	tcp_port = _tcp_server_result[1]
	udp_port = _udp_server_result[1]
}

function send_reliable_message(_message, _address) {
	var _buffer = buffer_create(256, buffer_grow, 1)
	buffer_write(_buffer, buffer_text, _message)

}

function process_message(_raw_content, _address) {
	var _message_data = unpack_message(_raw_content)
	var _content = _message_data[0]
	var _command = _message_data[1][0]
	var _arguments = _message_data[1]
	
	var _found_client_index = find_client(_address)
	
	
	switch _command {
		case "udp_port_sending":
		
		var _port = number_from_string(array_pick(_arguments, 1))
		var _ip = _content
		
		if _found_client_index != -1 && !is_nan(_port) {
			var _client = clients[_found_client_index]
			_client.udp_address = [_ip, _port]
		}
		
		break
		
		default:
		
		on_message_received.fire([_raw_content, _address])
		
		break
	}
	
}