/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _gui_width = display_get_gui_width()
var _gui_height= display_get_gui_height()

var _camera_size = camera.get_size()
var _ammo_text = ""
var _text_x =_gui_width * .9
var _text_y = _gui_height * .9


if touchscreen_mode {
	draw_virtual_joystick(_gui_width, _gui_height)
}

if character.equipped_gun_manager.gun_information != noone {
	var _loaded_ammo = get_from_struct(character.equipped_gun_manager.gun_information, "loaded_ammo", 0)
	var _bullet_type = get_from_struct(character.equipped_gun_manager.gun_information, "bullet_type", BULLET_TYPE.LIL_GUY)
	var _ammo = character.backpack.get_ammo(_bullet_type)
	
	_ammo_text = string_concat(_loaded_ammo, "/",_ammo)
}



if character.equipped_gun_manager.reloading && character.equipped_gun_manager.gun_information != noone {
	
	
	draw_progress_circle(
		_gui_width*.5,
		_gui_height*.5,
		character.equipped_gun_manager.timer/character.equipped_gun_manager.gun_information.reload_time,
		0.6
	)
	
	draw_set_alpha(.5)
	
} else {
	draw_set_alpha(1)
}

// Dibujar el contorno (alrededor del texto)
draw_set_color(c_black);
draw_set_halign(fa_right)
draw_set_valign(fa_bottom)
draw_set_font(fnt_current_gun_ammo)


for (var _dx = -3; _dx <= 3; _dx++) {
    for (var _dy = -3; _dy <= 3; _dy++) {
        // Evitar dibujar en el centro (donde irá el texto principal)
        if (_dx != 0 || _dy != 0) {
            draw_text(_text_x + _dx, _text_y + _dy, _ammo_text);
        }
    }
}

// Dibujar el texto principal encima del contorno
draw_set_color(c_white);
draw_text(_text_x, _text_y, _ammo_text);


draw_set_alpha(1)
draw_set_halign(fa_left)

draw_aim()
draw_inventory()

/*var _muzzle_position = character.equipped_gun_manager.get_muzzle_position()

if _muzzle_position != noone {
	
	draw_sprite(
		spr_aim_01,
		0,
		character.x + _muzzle_position.x,
		character.y + _muzzle_position.y
	)
}*/



draw_healthbar(
	30,
	_camera_size.y - 50,
	300,
	_camera_size.y - 30,
	character.hp/character.max_hp * 100,
	c_red,
	c_green,
	c_green,
	0,
	true,
	false
)






