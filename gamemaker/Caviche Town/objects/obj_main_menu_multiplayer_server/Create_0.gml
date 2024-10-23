/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

server_socket = instance_find(obj_udp_server, 0)
server_socket.init()

function create_client_element(_client_id) {
	var _hlayout = instance_create_layer(0,0, layer, obj_container)
	_hlayout.spacing = 20
	_hlayout.relative_width = 1
	_hlayout.relative_height = 0.08
	_hlayout.disposition = CONTAINER_DISPOSITION.HORIZONTAL_LAYOUT
	
	var _text_label = instance_create_layer(0,0, layer, obj_text_label)
	_text_label.text = "Jugador#"
	
}

server_name_input = create_text_input("Nombre del servidor", .1, .1, 0,0, .8, .1)
server_password_input = create_text_input("Contraseña", .1, .25, 0,0, .5, .1)
server_max_players_input = create_text_input("Jugadores máximos (4)", .65, .25, 0,0, .25, .1)

var _last_server_data = load_value("server_creation_last_data", undefined)

if is_struct(_last_server_data) {
	server_socket.max_clients = _last_server_data.max_clients
	server_socket.server_name = _last_server_data.name
	server_socket.password = _last_server_data.password
	
	server_name_input.set_text(_last_server_data.name)
	server_max_players_input.set_text(string(_last_server_data.max_clients))
	server_password_input.set_text(string(_last_server_data.password))
	
	delete _last_server_data
}

server_name_input.allowed_characters = USERNAME_ALLOWED_CHARS + " "
server_name_input.max_length = 30
server_name_input.virtual_keyboard.type = kbv_type_ascii
server_name_input.input_events.on_text_changed.add_listener(function() {
	server_socket.server_name = server_name_input.typed_text
	
	if string_length(server_socket.server_name) <= 0 {
		server_socket.server_name = "Sin nombre"
	}
})

server_password_input.allowed_characters = ASCII_CHARS
server_password_input.max_length = 30
server_password_input.virtual_keyboard.type = kbv_type_ascii
server_password_input.input_events.on_text_changed.add_listener(function() {
	server_socket.password = server_password_input.typed_text
})

server_max_players_input.allowed_characters = DIGITS
server_max_players_input.max_length = 2
server_max_players_input.virtual_keyboard.type = kbv_type_numbers

server_max_players_input.max_number = 32
server_max_players_input.min_number = 1

server_max_players_input.input_events.on_text_changed.add_listener(function() {
	
	var _connected_clients_count = array_length(server_socket.connected_clients)
	server_max_players_input.min_number =  _connected_clients_count >= 1 ? _connected_clients_count : 1
	
	var _max_clients_number = number_from_string(server_max_players_input.typed_text)
	
	if is_nan(_max_clients_number) {
		server_socket.max_clients = 4
	} else {
		server_socket.max_clients = floor(_max_clients_number)
	}
})

bg_rectangle = instance_create_layer(0,0, layer, obj_rectangle)

bg_rectangle.color = c_black
bg_rectangle.background_alpha = .3
bg_rectangle.relative_position_x  = .1
bg_rectangle.relative_position_y  = .4
bg_rectangle.relative_width = .8
bg_rectangle.relative_height = .35

connected_peers_container = instance_create_layer(0,0, layer, obj_scroll_container)

connected_peers_container.relative_position_x  = bg_rectangle.relative_position_x
connected_peers_container.relative_position_y  = bg_rectangle.relative_position_y
connected_peers_container.relative_width = bg_rectangle.relative_width
connected_peers_container.relative_height = bg_rectangle.relative_height


back_button = create_canvas_button_with_rel_size("Volver", 0.1, .8, .1, .1)

back_button.events.on_mouse_click.add_listener(function(){change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")})

start_game_button = create_canvas_button_with_rel_size("Iniciar", 0.25, 0.8, 0.65, 0.1)