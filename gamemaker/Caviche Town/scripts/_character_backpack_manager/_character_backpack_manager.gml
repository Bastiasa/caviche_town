// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function CharacterBackpackManager(_character = noone) constructor {
	lil_guys = 0
	medium_bullets = 0
	big_jocks = 0
	shells = 0
	rockets = 0
	
	max_lil_guys = 500
	max_medium_bullets = 500
	max_big_jocks = 500
	max_shells = 500
	max_rockets = 12
	
	max_guns = 3
	guns = array_create(max_guns, noone)

	function first_busy_slot(_offset = 0, _reversed = false) {
		
		var _result = -1
		var _guns_array = guns
		
		if _reversed {
			_guns_array = array_reverse(guns, 0, max_guns)
			_offset = max_guns - 1 - _offset
		}
		
		for(var _slot = _offset; _slot < max_guns; _slot++) {
			if _guns_array[_slot] != noone {
				_result = _slot
				break
			}
		}
		
		return !_reversed ? _result : max_guns - 1 - _result
	}
	
	function get_gun_slot(_gun_information) {
		if _gun_information == noone {
			return -1
		}
		
		return array_get_index(guns, _gun_information)
	}

	function clear_guns() {
		guns = array_create(max_guns, noone)
	}
	
	function clear_ammo() {
		rockets = 0
		lil_guys = 0
		medium_bullets = 0
		big_jocks = 0
	}

	function get_gun(_index) {
		if array_length(guns) >= _index+1 {
			return guns[_index]
		}
		
		return noone
	}
	
	function put_gun(_gun_information, _slot) {
		guns[_slot] = _gun_information
	}
	
	function free_slot() {
		return array_get_index(guns, noone)
	}
	
	function has_gun(_name) {
		for(var _index = 0; _index < array_length(guns); _index++) {
			var _gun_information = guns[_index]
			
			if _gun_information != noone && _gun_information.name == _name {
				return true
			}
		}
		
		return false
	}
	
	function add_gun(_information) {
		var _free_slot = free_slot()
		
		if _free_slot != noone {
			guns[_free_slot] = _information
			return true
		}
		
		return false
	}
	
	function remove_gun(_index) {
		guns[_index] = noone
	}
	
	function get_ammo(_type) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: return lil_guys
			break
			
			case BULLET_TYPE.MEDIUM: return medium_bullets
			break
			
			case BULLET_TYPE.BIG_JOCK: return big_jocks
			break
			
			case BULLET_TYPE.SHELL: return shells
			break
			
			case BULLET_TYPE.ROCKET: return rockets
			break
			
			default: return noone
			break
		}
	}
	
	function get_max_ammo(_type) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: return max_lil_guys
			break
			
			case BULLET_TYPE.MEDIUM: return max_medium_bullets
			break
			
			case BULLET_TYPE.BIG_JOCK: return max_big_jocks
			break
			
			case BULLET_TYPE.ROCKET: return max_rockets
			break
			
			case BULLET_TYPE.SHELL: return max_shells
			break
			
			default: return noone
			break
		}
	}
		
	function set_ammo(_type, _new_ammo) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: lil_guys = clamp(_new_ammo, 0, max_lil_guys); break
			case BULLET_TYPE.MEDIUM: medium_bullets = clamp(_new_ammo, 0, max_medium_bullets); break
			case BULLET_TYPE.BIG_JOCK: big_jocks = clamp(_new_ammo, 0, max_big_jocks); break
			case BULLET_TYPE.SHELL: shells = clamp(_new_ammo, 0, max_shells); break
			case BULLET_TYPE.ROCKET: rockets = clamp(_new_ammo, 0, max_rockets); break
			default: return false; break
		}
		
		return true
	}
}