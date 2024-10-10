/// @description Inserte aquí la descripción
// Puede escribir su código en este editor



connected_server_address = noone
client = noone

state = UDP_CLIENT_STATE.DISCONNECTED

events = {
	on_disconnected: new Event(),
	on_connected: new Event()
}

function address_to_string(_address) {
	return string_concat(_address[0],":",_address[1])
} 
	
function send_message(_message, _address) {
	var _length = string_length(_message)
	var _buffer = buffer_create(_length, buffer_grow, 1)
	buffer_write(_buffer, buffer_string, _message)
	
	var _result = network_send_udp_raw(client, _address[0], _address[1], _buffer, _length)
	
	if _result {
		show_debug_message(string_concat("Message has been sent to ",_address[0],":",_address[1],"."))
	} else {
		show_debug_message(string_concat("Message to ",_address[0],":",_address[1]," has failed."))
	}
	
	buffer_delete(_buffer)
	return _result
}

function connect_to_server(_url, _port, _password = "") {
	
	show_debug_message(string_concat("Trying to connect to ",_url,":",_port,"."))
	client = network_create_socket(network_socket_udp)
	var _address = [_url, _port]
	var _connect_message = send_message("connection_request:"+_password, _address)

	
	if _connect_message {
		show_debug_message("Connection request sended. Waiting for response.")
		connected_server_address = _address
		state = UDP_CLIENT_STATE.CONNECTING
		return true
	} else {
		show_debug_message("Connection failed.")
		connected_server_address = noone
		network_destroy(client)
		return false
	}
	
}

function is_server(_address) {
	return client != noone && connected_server_address != noone && _emisor[0] == connected_server_address[0] && _emisor[1] == connected_server_address[1]
}


function process_reliable_message(_message, _id, _emisor) {
	
	var _is_server = is_server(_emisor)
	
	if _message == "connection_destroyed" && _is_server {
		state = UDP_CLIENT_STATE.DISCONNECTED
		connected_server_address = noone
		network_destroy(client)
		events.on_disconnected.fire()

		show_debug_message("Disconnected from server.")
	}
	
	if _message == "connection_successfully" && _is_server {
		state = UDP_CLIENT_STATE.CONNECTED
		events.on_connected.fire()
		
		show_debug_message("Connected to server successfully.")
	}
	
	
	send_message(string_concat("reliable_received#",_id), _emisor)

}

function process_server_message(_message, _emisor) {
	
	var _is_server = is_server(_emisor)
	
	if string_starts_with(_message, "reliable#") {
		var _message_parts = string_split(_message, ":", false, true)
		
		var _message_information = _message_parts[0]
		var _message_content = _message_parts[1]
		
		var _message_id = string_split(_message_information, "#", false, 1)[1]
		_message_id = int64(string_digits(_message_id))
		
		process_reliable_message(_message_content, _message_id, _emisor)
	}
}

