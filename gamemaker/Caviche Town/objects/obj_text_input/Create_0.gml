/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

typed = false
timer = 0
cursor = 0

cursor_timer = 0
cursor_alpha = 0.6
cursor_color = c_black
cursor_thickness = 3

text = ""
placeholder = "Tangamandapio"

_normal_text_color = text_color
placeholder_color = c_gray

text_surface = create_surface()

text_wrapping = false

padding_x = 30
padding_y = 5

text_horizontal_align = fa_left
text_color = c_black
placeholder_color = c_gray

outline_color = c_black
color = c_white

modal = true

virtual_keyboard = {
	type: kbv_type_default,
	return_type: kbv_type_default,
	autocapitalize: kbv_autocapitalize_sentences,
	predictivie_text_enabled: true
}

cooldown = 0.5

events.on_mouse_up.add_listener(function() {
	if global.ui_manager.active_element == self {
		keyboard_virtual_show(virtual_keyboard.type, virtual_keyboard.return_type, virtual_keyboard.autocapitalize, virtual_keyboard.predictivie_text_enabled)
	}
})

events.on_blur.add_listener(function() {
	keyboard_virtual_hide()
})