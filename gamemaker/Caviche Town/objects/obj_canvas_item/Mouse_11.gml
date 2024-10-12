/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
is_mouse_inside = false

if global.ui_manager.mouse_keeper == self {
	global.ui_manager.set_mouse_keeper(noone)
}

events.on_mouse_leave.fire()