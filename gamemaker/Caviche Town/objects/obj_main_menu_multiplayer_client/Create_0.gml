event_inherited()

ip_input = create_text_input("Dirección IP", 0.5, 0.35, 0, 0, .4, 0.1, layer)
port_input = create_text_input("Puerto", 0.5, 0.5, 0, 0, .4, 0.1, layer)
password_input = create_text_input("Contraseña", 0.5, 0.25, 0, 0, .4, 0.1, layer)

port_input.max_number = 6000
port_input.min_number = 0
port_input.max_length = 5
port_input.allowed_characters = DIGITS
port_input.virtual_keyboard.type = kbv_type_numbers

ip_input.allowed_characters = ASCII_CHARS
ip_input.virtual_keyboard.type = kbv_type_url

join_button = create_canvas_button_with_rel_size("Unirse", .5, .65, .4, .1, layer)
back_button = create_canvas_button_with_rel_size("Volver", .5, .8, .4, .1, layer)

join_button.events.on_mouse_click.add_listener(function() {
	var _spawner = change_to_spawner(obj_main_menu_client_connecting, "multiplayer_client_connecting", false)
	
	var _port = number_from_string(port_input.typed_text)
	var _ip = ip_input.typed_text
	var _password = password_input.typed_text
	
	
	_spawner.
})

back_button.events.on_mouse_click.add_listener(function() {
	change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")
})

set_items_offset([ip_input, port_input, join_button, back_button], .5, .5)