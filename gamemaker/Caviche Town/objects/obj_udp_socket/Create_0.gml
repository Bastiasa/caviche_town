/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

socket = noone

reliable_engine = {
	received: {},
	sent: [],
	
	queue:[],
	
	current: undefined,
	current_time: 0,
	timeout: 5,
	
	
	next_send_id: -1
}


events = {
	on_message_received: new Event()
}

function address_to_string(_address) {
	return string_concat(_address[0],":",_address[1])
} 

function init(_port = undefined) {
	
	if is_real(_port) {
		socket = network_create_socket_ext(network_socket_udp,_port)
	} else {
		socket = network_create_socket(network_socket_udp)
	}
	
	show_debug_message(string_concat("Socket connection done: ", socket))
	
	return socket >= 0
}

function get_reliable_messsage_information(_id) {
	var _result = undefined
	
	for(var _index = 0; _index < array_length(reliable_engine.sent); _index++) {
		var _sent_reliable_information = reliable_engine.sent[_index]
			
		if _id == _sent_reliable_information.id {
			_result = _sent_reliable_information
			break
		}
	}
	
	return _result
}

function remove_reliable_message(_reliable_message_id) {
	if !is_numeric(_reliable_message_id) {
		return false
	}
	
	for(var _index = 0; _index < array_length(reliable.messages); _index++) {
		var _reliable_message_information = reliable.messages[_index]
		
		if _reliable_message_information.id == _reliable_message_id {
			array_delete(reliable.messages, _index, 1)
			
			if is_callable(_reliable_message_information.on_received) {
				reliable.on_received()
			}
			
			delete _reliable_message_information
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
	show_debug_message(_message)
	show_debug_message("")
	
	var _length = string_length(_message)
	var _buffer = buffer_create(_length, buffer_grow, 1)
	
	buffer_write(_buffer, buffer_text, _message)
	
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

function send_ack(_id, _emisor) {
	send_message(string_concat("ack,",_id), _emisor)
}

function create_reliable_message(_message, _address, _on_received = noone, _on_cancelled = noone) {
	reliable_engine.next_send_id++
	
	var _id = reliable_engine.next_send_id
	var _content = string_concat("r,",_id,":",_message)

	var _info = {
		address: _address,
		content: _content,
		
		id: _id,
		
		start_time: current_time,
		
		on_cancelled: _on_cancelled,
		on_received: _on_received,
		
		done: false,
		
		reliable_check_message: string_concat("rc,", _id)
	}
	
	array_push(reliable_engine.sent, _info)
	return _info
}

function prepare_reliable_message(_message, _address, _max_retries = 5) {
	
	if socket == noone {
		return false
	}
	
	show_debug_message("Sending "+_message)
		
	var _reliable_information = create_reliable_message(_message, _address)
	_reliable_information.retries = _max_retries
	
	var _result = send_message(_reliable_information.content, _address)
	return _reliable_information
} 

function send_reliable_message(_message, _address) {
	
	if socket == noone {
		return false
	}
	show_debug_message(_message)
	array_push(reliable_engine.queue, [_message, _address])
} 

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

function handle_message(_message, _emisor) {

}

function process_message(_message, _emisor) {
	var _message_data = unpack_message(_message)
	var _content = _message_data[0]
	var _arguments = _message_data[1]
	var _command = _arguments[0]
	var _string_emisor = address_to_string(_emisor)

	switch _command {
	
		case "r": // Reliable message sent
		
		var _reliable_id = number_from_string(array_pick(_arguments, 1))
		
		if !is_real(_reliable_id) {
			return
		}
		
		var _received_from_this = get_from_struct(reliable_engine.received, _string_emisor, undefined)
		
		if !is_array(_received_from_this) {
			variable_struct_set(reliable_engine.received, _string_emisor, [_reliable_id])
		} else {
			array_push(_received_from_this, _reliable_id)
		}

		send_ack(_reliable_id, _emisor)
		handle_message(_content, _emisor)
		
		break
		
		case "rc": // Reliable check if received
		
		var _reliable_id = number_from_string(array_pick(_arguments, 1))
		
		if !is_real(_reliable_id) {
			return
		}
		
		var _received_from_this = get_from_struct(reliable_engine.received, _string_emisor, undefined)
		
		if _received_from_this == undefined || !array_contains(_received_from_this, _reliable_id) {
			send_message(string_concat("rr,",_reliable_id), _emisor)
		} else {
			send_ack(_reliable_id, _emisor)
		}
		
		break
		
		case "rr": //Reliable message resend
		
		var _reliable_id = number_from_string(array_pick(_arguments, 1))
		
		if !is_real(_reliable_id) {
			return
		}
		
		var _sent_reliable_information = get_reliable_messsage_information(_reliable_id)
		
		if _sent_reliable_information != undefined {
			send_message(_sent_reliable_information.content, _sent_reliable_information.address)
		}
		
		break
		
		case "ack": //Reliable message acknowledged
		
		var _reliable_id = number_from_string(array_pick(_arguments, 1))
		
		if !is_real(_reliable_id) {
			return
		}
		
		var _sent_reliable_information = get_reliable_messsage_information(_reliable_id)
		
		if _sent_reliable_information != undefined {
			_sent_reliable_information.done = true
			
			if is_callable(_sent_reliable_information.on_received) {
				_sent_reliable_information.on_received()
			}
		}
		
		break
		
		default:
		
		handle_message(_message, _emisor)
		
		break
	}
	
}
