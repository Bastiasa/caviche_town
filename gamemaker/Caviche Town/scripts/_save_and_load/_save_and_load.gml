// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información

global._tmp_storing_data = {}

function _save_storing_data() {
	var _raw_json = json_stringify(global._tmp_storing_data)
	var _buffer = buffer_create(string_length(_raw_json), buffer_grow, 1)
	
	buffer_write(_buffer, buffer_text, _raw_json)
	buffer_save(_buffer, "stored_data.json")
	buffer_delete(_buffer)
}

function _load_storing_data() {
	var _buffer = buffer_load("stored_data.json")
	
	if _buffer < 0 {
		return noone
	} else {
		
		try {
			var _raw_json = buffer_read(_buffer, buffer_text)
			var _json = json_parse(_raw_json, noone, true)	
			
			buffer_delete(_buffer)
			return _json
			
		} catch(_err) {
			show_debug_message("Error while stored_data.json content: "+string(_err))
		}
		
		buffer_delete(_buffer)
		return noone
	}
}

global._tmp_storing_data = _load_storing_data()

if global._tmp_storing_data == noone {
	global._tmp_storing_data = {}
	_save_storing_data()
}

function save_value(_key, _value) {
	variable_struct_set(global._tmp_storing_data, _key, _value)
}

function load_value(_key, _default_value = noone) {
	if !variable_struct_exists(global._tmp_storing_data, _key) {
		return _default_value
	} else {
		return variable_struct_get(global._tmp_storing_data, _key)
	}
}