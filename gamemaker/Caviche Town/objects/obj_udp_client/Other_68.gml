/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
var _event_type = async_load[?"type"] 
var _socket = async_load[? "socket"]

if _event_type == network_type_data && client == _socket {

    var _ip_address = async_load[? "ip"]
    var _port = async_load[? "port"]
    var _buffer = async_load[? "buffer"]
	
    var _message = buffer_read(_buffer, buffer_string);
	
    show_debug_message("New message from" + _ip_address + ":" + string(_port));
    show_debug_message(" " + _message+"\n");
	
	process_server_message(_message, [_ip_address, _port])
	
    buffer_delete(_buffer);
	
}