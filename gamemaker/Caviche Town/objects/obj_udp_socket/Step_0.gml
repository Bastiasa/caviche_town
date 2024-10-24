/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

/*
  for(var _index = 0; _index < array_length(reliable.messages); _index++) {
	var _reliable_message_information = reliable.messages[_index]
		
	if current_time - _reliable_message_information.start_time >= reliable.timeout * 1000 && _reliable_message_information.retries > 0{
		_reliable_message_information.start_time = current_time
		send_message(_reliable_message_information.content, _reliable_message_information.address)
		_reliable_message_information.retries--
		
	} else if _reliable_message_information.retries <= 0 {
		remove_reliable_message(_reliable_message_information.id)
		
		if is_callable(_reliable_message_information.on_cancelled) {
			_reliable_message_information.on_cancelled()
		}
	}
}

*/

if is_struct(reliable_engine.current) {
	
	if !reliable_engine.current.done {
		send_message(reliable_engine.current.reliable_check_message, reliable_engine.current.address)
	}
	
	var _message_timeout = reliable_engine.timeout*1000 <= current_time - reliable_engine.current_time
	
	if reliable_engine.current.done || _message_timeout {
		
		if is_callable(reliable_engine.current.on_cancelled) && _message_timeout {
			reliable_engine.current.on_cancelled()
			show_debug_message("Reliable message has timeout.")
		} else {
			show_debug_message("Reliable has been sent.")
		}
		
		
		reliable_engine.current = undefined
	}
}


if !is_struct(reliable_engine.current) {
	var _next_message_data = array_shift(reliable_engine.queue)
	
	if is_array(_next_message_data) {
		reliable_engine.current_time = current_time
		reliable_engine.current = prepare_reliable_message(_next_message_data[0], _next_message_data[1])
	}
}