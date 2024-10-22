
event_inherited()

create_server_button = create_canvas_button_with_rel_size(
	"Crear servidor",
	0.1,
	0.4,
	0.3,
	0.1,
	"multiplayer"
)

create_server_button.events.on_mouse_click.add_listener(function() {change_to_spawner(obj_main_menu_multiplayer_server, "multiplayer_client")})

search_server_button = create_canvas_button_with_rel_size(
	"Unirse a servidor",
	0.6,
	0.4,
	0.3,
	0.1,
	"multiplayer"
)

search_server_button.events.on_mouse_click.add_listener(function() {change_to_spawner(obj_main_menu_multiplayer_client, "multiplayer_client")})

get_back_button = create_canvas_button_with_rel_size("Volver",  0.5, 0.6, 0.3, .1, layer)

get_back_button.events.on_mouse_click.add_listener(function(){
	change_to_spawner(obj_main_menu_buttons_spawner, "main_menu")
})

get_back_button.offset_x = .5
get_back_button.offset_y = .5


