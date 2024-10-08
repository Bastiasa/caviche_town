/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _camera_size = camera.get_size()
var _text_position = _camera_size.subtract(new Vector(50,50))
var _ammo_text = "0/0"

if character.equipped_gun_manager.gun_information != noone {
	var _loaded_ammo = get_from_struct(character.equipped_gun_manager.gun_information, "loaded_ammo", 0)
	var _bullet_type = get_from_struct(character.equipped_gun_manager.gun_information, "bullet_type", BULLET_TYPE.LIL_GUY)
	var _ammo = character.backpack.get_ammo(_bullet_type)
	
	_ammo_text = string_concat(_loaded_ammo, "/",_ammo)
}



draw_set_halign(fa_right)
draw_set_font(fnt_current_gun_ammo)

if character.equipped_gun_manager.reloading && character.equipped_gun_manager.gun_information != noone {
	
	
	draw_progress_circle(
		_camera_size.x*.5,
		_camera_size.y*.5,
		character.equipped_gun_manager.timer/character.equipped_gun_manager.gun_information.reload_time,
		0.6
	)
	
	draw_set_alpha(.5)
	
} else {
	draw_set_alpha(1)
}

// Dibujar el contorno (alrededor del texto)
draw_set_color(c_black);

for (var _dx = -3; _dx <= 3; _dx++) {
    for (var _dy = -3; _dy <= 3; _dy++) {
        // Evitar dibujar en el centro (donde irá el texto principal)
        if (_dx != 0 || _dy != 0) {
            draw_text(_text_position.x + _dx, _text_position.y + _dy, _ammo_text);
        }
    }
}

// Dibujar el texto principal encima del contorno
draw_set_color(c_white);
draw_text(_text_position.x, _text_position.y, _ammo_text);


draw_set_alpha(1)
draw_set_halign(fa_left)

draw_aim()

/*var _muzzle_position = character.equipped_gun_manager.get_muzzle_position()

if _muzzle_position != noone {
	
	draw_sprite(
		spr_aim_01,
		0,
		character.x + _muzzle_position.x,
		character.y + _muzzle_position.y
	)
}*/

for (var _blood_spot_index = 0; _blood_spot_index < array_length(blood_spots); _blood_spot_index++) {
	var _blood_spot_data = blood_spots[_blood_spot_index]
	
	_blood_spot_data.lifetime -= get_delta()
	
	if _blood_spot_data.lifetime <= 0.3 && !character.died {
		_blood_spot_data.alpha = _blood_spot_data._alpha * (_blood_spot_data.lifetime/0.3)
	}
	
	draw_sprite_ext(
		spr_blood_spots,
		_blood_spot_data.subimg,
		_blood_spot_data.x * _camera_size.x,
		_blood_spot_data.y * _camera_size.y,
		_blood_spot_data.scale,
		_blood_spot_data.scale,
		0,
		c_white,
		_blood_spot_data.alpha
	)
	
	if _blood_spot_data.lifetime <= 0 && !character.died {
		array_delete(blood_spots, _blood_spot_index, 1)
	}
}


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

if character.equipped_gun_manager.gun_information != noone {
	
	draw_set_color(c_purple)
	
	draw_circle(
		character.x + character.equipped_gun_manager.get_offset_position().x - camera.position.x,
		character.y + character.equipped_gun_manager.get_offset_position().y - camera.position.y,
		2,
		0
	)
	
	draw_set_color(c_white)

}




