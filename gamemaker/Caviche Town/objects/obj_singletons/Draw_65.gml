/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
room_width = window_get_width()
room_height = window_get_height()

view_set_wport(0, window_get_width())
view_set_hport(0, window_get_height())
camera_set_view_size(view_camera[0], window_get_width(), window_get_height())