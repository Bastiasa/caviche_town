/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if parent != noone && object_get_parent(parent.object_index) == obj_canvas_item {
	surface_set_target(parent.surface)
} else {
	surface_reset_target()
}
