/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

event_inherited()

timer = 0
cursor = 0

text = ""
placeholder = ""

text_color = c_black
placeholder_color = c_gray

outline_color = c_black
color = c_white


virtual_keyboard = {
	type: kbv_type_default,
	return_type: kbv_type_default,
	autocapitalize: kbv_autocapitalize_sentences
}


focused = false
cooldown = 0.5
