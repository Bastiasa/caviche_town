/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

socket = noone

reliable = {
	timeout:4,
	next_id: -1,
	messages:[]
}

events = {
	on_message_received: new Event()
}

function address_to_string(_address) {
	return string_concat(_address[0],":",_address[1])
} 

function init(_port = undefined) {
	
	if is_int64(_port) {
		socket = network_create_socket_ext(network_socket_udp,_port)
	} else {
		socket = network_create_socket(network_socket_udp)
	}
}

function remove_reliable_message(_reliable_message_id) {
	if !is_numeric(_reliable_message_id) {
		return false
	}
	
	for(var _index = 0; _index < array_length(reliable.messages); _index++) {
		var _reliable_message_information = reliable.messages[_index]
		
		if _reliable_message_information.id == _reliable_message_id {
			array_delete(reliable.messages, _index, 1)
			return true
		}
	}
}

function send_buffer(_buffer, _address, _delete = false) {
	
	var _url = _address[0]
	var _port = _address[1]
	
	var _result = network_send_udp_raw(server, _url, _port, _buffer, buffer_tell(_buffer))
	
	if _delete {
		buffer_delete(_buffer)
	}
	
	return _result
}

function send_message(_message, _address) {
	
	var _url = _address[0]
	var _port = _address[1]
	
	var _length = string_length(_message)
	var _buffer = buffer_create(_length, buffer_grow, 1)
	
	buffer_write(_buffer, buffer_string, _message)
	var _result = network_send_udp_raw(socket, _url, _port, _buffer, _length)
	buffer_delete(_buffer)
	
	return _result
}

function send_reliable_message(_message, _address) {
	var _reliable_information = generate_message_id(_message, _address)
	send_message(_reliable_information.content, _address)
} 

function process_message(_message, _emisor) {}

function answer_reliable_message(_id, _emisor) {
	send_message(string_concat("reliable_received:",_id), _emisor)
}

events.on_message_received.add_listener(function(_args) {
	var _message = _args[0]
	var _emisor = _args[1]
	
	if string_starts_with(_message, "reliable#") {
		var _reliable_parts = string_split(_message, ":", false, 1)
		
		var _message_information = _reliable_parts[0]
		var _message_content = _reliable_parts[1]
		
		var _id = string_split(_message_information, "#", false, 1)[1]
		_id = int64(string_digits(_id))
		
		answer_reliable_message(_id, _emisor)
		_message = _message_content
	} 
	
	process_message(_message, _emisor)
})
