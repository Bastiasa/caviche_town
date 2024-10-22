/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

general_settings_button = create_canvas_button_with_rel_size(
	"General",
	.05,
	.1,
	
	.25,
	.1,
	"settings"
)

keyboard_settings_button = create_canvas_button_with_rel_size(
	"Teclado",
	.05,
	.2,
	
	.25,
	.1,
	"settings"
)



gamepad_settings_button = create_canvas_button_with_rel_size(
	"Control",
	.05,
	.3,
	
	.25,
	.1,
	"settings"
)

touchscreen_settings_button = create_canvas_button_with_rel_size(
	"Táctil",
	.05,
	.4,
	
	.25,
	.1,
	"settings"
)

sound_settings_button = create_canvas_button_with_rel_size(
	"Sonido",
	.05,
	.5,
	
	.25,
	.1,
	"settings"
)

get_back_button = create_canvas_button_with_rel_size(
	"Volver",
	.05,
	.9,
	
	.25,
	.1,
	"settings"
)

get_back_button.events.on_mouse_click.add_listener(function() {
	instance_create_layer(0,0, "main_menu", obj_main_menu_buttons_spawner)
	layer_destroy_instances("settings")
})

instance_destroy(id)