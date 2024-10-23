/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _type = async_load[?"type"]
var _id= async_load[?"id"]
var _ip = async_load[?"ip"]
var _port = async_load[?"port"]
var _address = [_ip, _port]

var _socket = async_load[?"socket"]
var _succeeded = async_load[?"succeeded"]

if _id == reliable_server {
	
	if _type == network_type_connect {
		append_client(_socket)
	} else if _type == network_type_disconnect {
		remove_client(_socket)
	} else if _type == network_type_data {
		var _buffer = async_load[?"buffer"]
		var _content = buffer_read(_buffer, buffer_text)
		
		process_reliable_message(_content)
		
		buffer_delete(_buffer)
	}
	
}

if _id == unreliable_server {
	
	if _type == network_type_data {
		var _buffer = async_load[?"buffer"]
		var _content = buffer_read(_buffer, buffer_text)
		
		process_message(_content, _address)
		
		buffer_delete(_buffer)
	}
}