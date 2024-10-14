var _event_type = async_load[?"type"]
var _id = async_load[? "id"]

if _event_type == network_type_data && _id == socket {
    
    var _ip_address = async_load[? "ip"]
    var _port = async_load[? "port"]
    var _buffer = async_load[? "buffer"]
	 
	if !buffer_exists(_buffer) {
		return
	}
	
	var _message = buffer_read(_buffer, buffer_text);
	
	show_debug_message(string_concat("Incoming message from ", _ip_address,":",_port,"."))
	show_debug_message(string_concat(_message, "\n"))
	
	if is_array(_ip_address) {
		for(var _index = 0; _index < array_length(_ip_address); _index++) {
			var _ip = _ip_address[_index]
			
			if !is_string(_ip) {
				continue
			}
			
			if string_starts_with(_ip, "192.168.") {
				_ip_address = _ip
				break
			}
		}
	}
	
	if  !is_string(_ip_address) {
		return
	}
	
	events.on_message_received.fire([_message, [_ip_address, _port]])

    buffer_delete(_buffer);
}