/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _x = x - width * offset_x
var _y = y - height * offset_y

var _is_in_x = mouse_x > _x && mouse_x < _x+width
var _is_in_y = mouse_y > _y && mouse_y < _y+height

if _is_in_x && _is_in_y {
	keyboard_virtual_show(kbv_type_url,kbv_returnkey_default,kbv_autocapitalize_words, true)
	focused = true
} else {
	focused = false
}

