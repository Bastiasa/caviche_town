/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


timer = 0

delay = .5
animation_duration = 1


banner_sprite = spr_banner

start_pos = -.1
end_pos = .45

timer = -delay

spawner = instance_create_layer(0,0, "main_menu", obj_main_menu_buttons_spawner)

buttons = [
	spawner._quick_game_button,
	spawner._multiplayer_button,
	spawner._settings_button
]

buttons_animation_duration = 3.5

array_foreach(buttons, function(_button) {
	_button.relative_position_y = 1.5
})

audio_play_sound(snd_main_menu_begin_melody, 1, false)