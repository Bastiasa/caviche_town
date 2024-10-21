/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

global.rooms.main_menu.draw_banner = true

_quick_game_button = instance_create_layer(x,y, "main_menu", obj_button)
_multiplayer_button = instance_create_layer(x,y, "main_menu", obj_button)
_settings_button = instance_create_layer(x,y, "main_menu", obj_button)

_quick_game_button.text = "Partida rápida"
_multiplayer_button.text = "Multijugador"
_settings_button.text = "Ajustes"

_quick_game_button.relative_position_y = .55
_multiplayer_button.relative_position_y = .65
_settings_button.relative_position_y = .75

array_foreach([_quick_game_button, _multiplayer_button, _settings_button], function(_button) {
	_button.offset_x = .5
	_button.offset_y = .5
	_button.relative_position_x = .5
	
	_button.width = 400
	draw_set_font(fnt_ui)
	_button.height = string_height(_button.text) + 10
	_button.events.on_mouse_click.add_listener(function() {
		global.rooms.main_menu.draw_banner = false
		layer_destroy_instances("main_menu")
	})
})


_settings_button.events.on_mouse_click.add_listener(function() {
	change_to_spawner(obj_main_menu_settings_spawner, "settings")
})

_multiplayer_button.events.on_mouse_click.add_listener(function() {
	change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")
})
