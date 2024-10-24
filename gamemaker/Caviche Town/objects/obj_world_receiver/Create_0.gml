/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


client_socket = instance_find(obj_udp_client, 0)
server_socket = instance_find(obj_udp_server, 0)

on_client_message_received = -1
on_server_message_received = -1


function handle_message(_message, _emisor) {
	var _message_data = client_socket.unpack_message(_message)
	var _content = _message_data[0]
	var _command = _message_data[1][0]
	var _arguments = _message_data[1]
	
	switch _command {
	
		case "player_pos":
			
		var _player_id = number_from_string(array_pick(_arguments, 1))
		var _pos_x = number_from_string(array_pick(_arguments, 2))
		var _pos_y = number_from_string(array_pick(_arguments, 3))
		
		if is_nan(_player_id) || is_nan(_pos_x) || is_nan(_pos_y) {
			return
		}
			
		break
	
	}
	
}


on_client_message_received = client_socket.events.on_message_received.add_listener(handle_message)
on_server_message_received = server_socket.events.on_message_received.add_listener(handle_message)