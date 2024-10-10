/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

socket = noone

received_reliables = {}

reliable = {
	timeout:4,
	max_retries: 4,
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
	
	return socket > 0
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
	
	if socket == noone {
		return false
	}
	
	var _url = _address[0]
	var _port = _address[1]
	
	var _result = network_send_udp_raw(socket, _url, _port, _buffer, buffer_tell(_buffer))
	
	if _delete {
		buffer_delete(_buffer)
	}
	
	return _result
}

function send_message(_message, _address) {
	
	if socket == noone {
		return false
	}
	
	var _url = _address[0]
	var _port = _address[1]
	
	show_debug_message(string_concat("Sending messsage to: ", _url,":",_port))
	
	var _length = string_length(_message)
	var _buffer = buffer_create(_length, buffer_grow, 1)
	
	buffer_write(_buffer, buffer_string, _message)
	
	var _result = send_buffer(_buffer, _address, true)
	/*buffer_write(_buffer, buffer_string, _message)
	var _result = network_send_udp_raw(socket, _url, _port, _buffer, _length)
	buffer_delete(_buffer)*/
	
	if _result <= 0 {
		show_debug_message(string_concat("Message to: ", _url,":",_port, " has failed."))
	} else if _result < _length {
		show_debug_message(show_debug_message(string_concat("Message to: ", _url,":",_port, " was sent uncomplete.")))
	}
	
	return _result
}

function generate_message_id(_message, _address) {
	reliable.next_id++
	
	var _id = reliable.next_id
	var _content = string_concat("reliable#",_id,":",_message)

	var _info = {retries:reliable.max_retries, address:_address, content:_content, id:_id, start_time: current_time}
	
	array_push(reliable.messages, _info)
	return _info
}

function send_reliable_message(_message, _address) {
	
	if socket == noone {
		return false
	}
		
	var _reliable_information = generate_message_id(_message, _address)
	var _result = send_message(_reliable_information.content, _address)
	return _result
} 

function process_message(_message, _emisor) {}

function answer_reliable_message(_id, _emisor) {
	send_message(string_concat("reliable_received:",_id), _emisor)
}

events.on_message_received.add_listener(function(_args) {
	var _message = _args[0]
	var _emisor = _args[1]
	
	show_debug_message("Message from "+address_to_string(_emisor))
	
	if string_starts_with(_message, "reliable#") {
		var _reliable_parts = string_split(_message, ":", false, 1)
		
		var _message_information = _reliable_parts[0]
		var _message_content = _reliable_parts[1]
		
		var _id = string_split(_message_information, "#", false, 1)[1]
		_id = int64(string_digits(_id))
		
		answer_reliable_message(_id, _emisor)
		_message = _message_content
		
		if variable_struct_exists(received_reliables, address_to_string(_emisor)) {
			var _received_reliables_from_emisor = variable_struct_get(received_reliables, address_to_string(_emisor))
			var _found_received_reliable_id = array_get_index(_received_reliables_from_emisor, _id)
			
			if _found_received_reliable_id != -1 {
				answer_reliable_message(_id, _emisor)
				return
			} else {
				array_push(_received_reliables_from_emisor, _id)
			}
			
		} else {
			variable_struct_set(received_reliables, address_to_string(_emisor), [_id])
		}
	} 
	
	process_message(_message, _emisor)
})
