/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
event_inherited()

next_spawner = noone
prev_spawner = noone

last_username = load_value("username", "")
global.username = last_username

username_input = create_text_input("Nickname (Opcional)", .5, .5, 0,0, 0.5, .1)

username_input.input_events.on_text_changed.add_listener(function() {
	global.username = username_input.typed_text
})

username_input.set_text(last_username)
username_input.allowed_characters = USERNAME_ALLOWED_CHARS
username_input.virtual_keyboard.type = kbv_type_url
username_input.max_length = 30

username_input.offset_x = .5
username_input.offset_y = 1

back_button = create_canvas_button_with_rel_size("Cancelar", .5, .55, .2, .1)

back_button.offset_x = - .1

back_button.events.on_mouse_click.add_listener(function() {
	if prev_spawner != noone {
		change_to_spawner(prev_spawner[0], prev_spawner[1])
	}
})

next_button = create_canvas_button_with_rel_size("Continuar", .5, .55, .22, .1)

next_button.offset_x = 1.1


next_button.events.on_mouse_click.add_listener(function() {
	if next_spawner != noone {
		change_to_spawner(next_spawner[0], next_spawner[1])
	}
})





