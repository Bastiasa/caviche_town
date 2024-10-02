// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información

enum BULLET_TYPE {
	SHORT,
	LONG
}

function GunInformation(_bullet_type = BULLET_TYPE.SHORT, _muzzle_offset = new Vector(0,0), _bullet_initial_speed = 300, _bullet_deceleration = 10, _bullet_scale = 4, _cooldown_end = 0.3) constructor {
	bullet_type = _bullet_type
	bullet_initial_speed = _muzzle_offset
	bullet_deceleration  = _bullet_deceleration
	muzzle_offset = _muzzle_offset
	bullet_scale = _bullet_scale
	cooldown_end = _cooldown_end
	
	function get_muzzle_position(_gun_position_x, _gun_position_y, _gun_rotation) {
		var _result = new Vector(0,0)
		
		return _result
	}
}