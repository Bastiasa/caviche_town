/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if !global.rooms.main_menu.draw_banner {
	return
}

var _gui_width = display_get_gui_width()
var _gui_height = display_get_gui_height()


var _progress = timer / animation_duration
_progress = min(1, _progress)

var _y = _progress * (end_pos - start_pos)


draw_sprite_ext(
	banner_sprite,
	0,
	_gui_width*.5,
	_gui_height * _y,
	2,
	2,
	0,
	c_white,
	1
)

