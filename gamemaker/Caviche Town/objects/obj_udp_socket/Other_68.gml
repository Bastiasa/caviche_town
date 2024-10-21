var _event_type = async_load[?"type"]
var _id = async_load[? "id"]

if _event_type == network_type_data && _id == socket {
    
    var _ip_address = async_load[? "ip"]
    var _port = async_load[? "port"]
    var _buffer = async_load[? "buffer"]
	
	var _emisor = [_ip_address, _port]
	 
	if !buffer_exists(_buffer) {
		return
	}
	
	var _message = buffer_read(_buffer, buffer_text);
	
	show_debug_message(string_concat("Incoming message from ", _ip_address,":",_port,"."))
	show_debug_message(string_concat(_message, "\n"))
	
	if  !is_string(_ip_address) {
		return
	}
	
	if !is_real(_port) {
		return
	}
	
	process_message(_message, _emisor)
    buffer_delete(_buffer);
}