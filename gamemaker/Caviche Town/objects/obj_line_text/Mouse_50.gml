/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


var _is_in_x = mouse_x > x && mouse_x < x+width
var _is_in_y = mouse_y > y && mouse_y < y+height

if _is_in_x && _is_in_y {
	focused = true
} else {
	focused = false
}

