// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function is_player(_posible_player) {
	return _posible_player != noone && _posible_player.object_index == obj_character && _posible_player.controller != noone && _posible_player.controller.object_index == obj_player
}

function is_teammate(_character, _team) {
	return _character != noone && string_lower(_team) == string_lower(_character.team)
}

function lerp_angle(_from, _to, _weight) {
	_from = _from mod 360
	_to = _to mod 360
	
	var _difference = (_to - _from) mod 360
	
	if _difference > 180 {
		_difference -= 360	
	}
	
	return (_from + _difference * _weight) mod 360
}

function draw_progress_circle(_x,_y,_progress, _scale = 1, _alpha = 0.4) {
	
	
	// background circle
	draw_set_alpha(_alpha)
	draw_set_color(c_black)
	draw_circle(_x,_y, 32, false)
	
	draw_circular_bar(_x,_y,_progress,1, c_white, 24, 1, 10)
	
	draw_set_color(c_white)
	draw_set_alpha(1)
	
	/*var _info = sprite_get_info(spr_progress_circle)
	var _subimage = _progress * _info.num_subimages - 1
	show_debug_message(string_concat("Progress...",_progress))

	draw_set_color(c_black);
	for (var _dx = -2; _dx <= 2; _dx++) {
	    for (var _dy = -2; _dy <= 2; _dy++) {
	        if (_dx != 0 || _dy != 0) {
				
				draw_sprite_ext(
					spr_progress_circle,
					_info.num_subimages - 1,
					_x + _dx,
					_y + _dy,
					_scale,
					_scale,
					0,
					c_black,
					_alpha
				)
	        }
	    }
	}

	draw_sprite_ext(
		spr_progress_circle,
		_subimage,
		_x,
		_y,
		_scale,
		_scale,
		0,
		c_white,
		_alpha
	)*/
}


function array_choose(_array) {
	randomize()
	return array_get(_array, irandom(array_length(_array) - 1))
}

function addres_compare(_addr1, _addr2) {
	var _result = false
	
	if _addr1 == noone || _addr2 == noone || !is_array(_addr1) || !is_array(_addr2) {
		return false
	}
	
	if _addr1[0] == "localhost" {
		_addr1[0] = "127.0.0.1"
	}
	
	if _addr2[0] == "localhost" {
		_addr2[0] = "127.0.0.1"
	}
	return  _addr1[0] == _addr2[0] && _addr1[1] == _addr2[1]
}


function array_pick(_array, _index) {
	var _result = undefined
	
	try {
		_result = array_get(_array, _index)
	} catch(_err) {
	
	}
	
	return _result
}

function number_from_string(_str) {
	var _result = NaN
	
	try {
		_str = string_digits(_str)
		_result = real(_str)
	} catch(_err) {
	
	}
	
	return _result
}


function string_char_pos_on_width(_str, _width) {
	var _result = 0
	var _current_width = 0
	var _total_width = string_width(_str)
	
	for(var _index = 0; _index < string_length(_str) + 1; _index ++) {
		if _current_width >= min(_width, _total_width){
			_result = _index
			break
		}
		
		_current_width += string_width(string_char_at(_str, _index))
	}
	
	return _result
}

