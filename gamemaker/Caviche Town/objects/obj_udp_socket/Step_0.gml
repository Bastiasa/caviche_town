/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


for(var _index = 0; _index < array_length(reliable.messages); _index++) {
	var _reliable_message_information = reliable.messages[_index]
		
	if current_time - _reliable_message_information.start_time >= reliable.timeout * 1000 {
		_reliable_message_information.start_time = current_time
		send_message(_reliable_message_information.content, _reliable_message_information.address)
	}
}
