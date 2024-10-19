// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function create_and_init_explosion(_x,_y,_layer, _radius, _max_damage, _max_damage_range, _cause = noone) {
	var _explosion = instance_create_layer(_x,_y,_layer, obj_explosion)
	
	_explosion.radius = _radius
	_explosion.max_damage = _max_damage
	_explosion.max_damage_range = _max_damage_range
	_explosion.cause = _cause
	
	_explosion.init()
	return _explosion
}

function create_explosion(_x,_y,_layer, _radius, _max_damage, _max_damage_range, _cause = noone) {
	var _explosion = instance_create_layer(_x,_y,_layer, obj_explosion)
	
	_explosion.radius = _radius
	_explosion.max_damage = _max_damage
	_explosion.max_damage_range = _max_damage_range
	_explosion.cause = _cause
	
	return _explosion
}