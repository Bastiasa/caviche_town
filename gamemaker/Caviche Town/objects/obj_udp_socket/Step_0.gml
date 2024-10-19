/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


for(var _message_index = array_length(reliable.send_queue) - 1; _message_index >= 0; _message_index++) {
	
	var _message_information = send_queue[_message_index]
	var _message_content = _message_content.content
	var _message_destination = _message_content.destination
	
	reliable.next_id++
	var _message_id = reliable.next_id
	
	var _string_fragments = string_get_parts(_message_content, reliable.fragments_size)
	var _fragments = []
	
	send_reliable_message()
	
	for(var _index = 0; _index < array_length(_string_fragments); _index++) {
		
		var _fragment_content = _string_fragments[_index]
		_fragment_content = string_concat("part,",_message_id,",",_index,":",_fragment_content)
		
		var _buffer = buffer_create(string_length(_fragment_content), buffer_grow, 1)
		
		buffer_write(_buffer, buffer_text, _fragment_content)
		
		send_buffer(_buffer, _message_destination, true)	
	}
	
	array_delete(reliable.send_queue, _message_index, 1)
	
}

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
