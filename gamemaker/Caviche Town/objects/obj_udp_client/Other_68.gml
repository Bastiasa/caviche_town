/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

var _type = async_load[?"type"]

if _type == network_type_data {
	var _id = async_load[?"id"]
	var _buffer = async_load[?"buffer"]
	var _ip = async_load[?"ip"]
	var _port = async_load[?"port"]
	
	var _emisor = [_ip, _port]
	
	if _id == broadcasting_socket  && _buffer != undefined {
		try {
			var _message_content = buffer_read(_buffer, buffer_text)
			check_possible_server_broadcast(_message_content, _emisor)
		} catch(_err) {
		
		}
		
		buffer_delete(_buffer)

	}
}/* else if _type == "udp_broadcast_received" {
	var _ip = async_load[?"ip"]
	var _port = async_load[?"port"]
	var _message = async_load[?"message"]
	
	var _emisor = [_ip, _port]
	
	show_debug_message(string_concat("Broadcast received from ", address_to_string(_emisor)))
	check_possible_server_broadcast(_message, _emisor)
}
