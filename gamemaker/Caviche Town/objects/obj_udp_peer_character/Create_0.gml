/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

character = instance_create_layer(x,y, "characters", obj_character)
client_id = -1

client_socket = instance_find(obj_udp_client, 0)
server_socket = instance_find(obj_udp_server, 0)

on_client_message_received = -1
on_server_message_received = -1
on_peer_disconnected = -1
on_client_disconnected = -1

pos_x = x
pos_y = y

target_pos_x = 0
target_pos_y = 0

function on_someone_disconnected(_client_id) {
	if client_id == _client_id {
		character.apply_damage(character.max_hp)
		instance_destroy(id)
	}
}

function handle_message(_args) {
	
	var _message = _args[0]
	var _emisor = _args[1]
	
	var _message_data = client_socket.unpack_message(_message)
	var _content = _message_data[0]
	var _command = _message_data[1][0]
	var _arguments = _message_data[1]
	
	switch _command {
	
		case "char_data":
			
		var _player_id = number_from_string(array_pick(_arguments, 1))
		var _pos_x = number_from_string(array_pick(_arguments, 2))
		var _pos_y = number_from_string(array_pick(_arguments, 3))
		var _state = number_from_string(array_pick(_arguments, 4))
		var _tgt_pos_x = number_from_string(array_pick(_arguments, 5))
		var _tgt_pos_y = number_from_string(array_pick(_arguments, 6))

		if is_nan(_player_id) || is_nan(_pos_x) || is_nan(_pos_y) || is_nan(_state) {
			return
		}
		
		if _player_id == client_id {
			
			pos_x = _pos_x
			pos_y = _pos_y
			
			target_pos_x = _tgt_pos_x
			target_pos_y = _tgt_pos_y
			
			character.current_state = _state
		}
			
		break
		
		case "shoot":
		
		var _player_id = number_from_string(array_pick(_arguments, 1))
		
		if _player_id == client_id {
			character.equipped_gun_manager.shoot()
		}
		
		break
		
		case "reload":
		
		var _player_id = number_from_string(array_pick(_arguments, 1))
		
		if _player_id == client_id {
			character.equipped_gun_manager.reload()
		}
		
		break
		
		case "grenade":
		
		var _player_id = number_from_string(array_pick(_arguments, 1))
		
		if _player_id == client_id {
			character.throw_grenade()
		}
		
		break
		
		case "damage":
		
		var _player_id = number_from_string(array_pick(_arguments, 1))
		var _damage = number_from_string(array_pick(_arguments, 2))
		var _from_id = number_from_string(array_pick(_arguments, 3))

		if _player_id == client_id && !is_nan(_damage) {
			character.apply_damage(_damage)
		}
		
		break
	
	}
	
}

on_client_message_received = client_socket.events.on_message_received.add_listener(handle_message)
on_server_message_received = server_socket.events.on_message_received.add_listener(handle_message)

on_client_disconnected = server_socket.server_events.on_client_disconnected.add_listener(function(_args) {
	var _client_id = _args[0][2]
	on_someone_disconnected(_client_id)
})

on_peer_disconnected = client_socket.client_events.on_peer_disconnected.add_listener(function(_args) {
	on_peer_disconnected(_args[0])
})