/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

if socket != noone {
	var _char_data = string_join(
		",", 		
		"char_data",
		json_stringify(character.x),
		json_stringify(character.y),
		string(character.current_state),
		json_stringify(character.equipped_gun_manager.target_position.x),
		json_stringify(character.equipped_gun_manager.target_position.y)
	)



	socket.send_to_all_clients(_char_data)
}


