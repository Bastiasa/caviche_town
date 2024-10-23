
#macro MILLION 1000000
#macro ASCII_CHARS " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"
#macro DIGITS "1234567890"
#macro NUMERIC_CHARS DIGITS + ".-"
#macro NO_ACCENT_LETTERS "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#macro USERNAME_ALLOWED_CHARS NO_ACCENT_LETTERS + "._" + DIGITS
#macro SPECIAL_CHARS "!\"#$%&'()*+,-./0123456789:;<=>?@"
#macro UDP_BROADCASTING_PORT 8888


function Vector(_x = 0, _y = 0) constructor {
	x = _x
	y = _y
	
	// Vector properties
	
	static abs = function() {
		return new Vector(abs(x), abs(y))
	}
	
	static angle = function() {
		return point_direction(0,0, x,y) * pi/180
	}
	
	static magnitude = function() {
		return sqrt(power(x, 2) + power(y, 2))
	}
	
	static negative = function() {
		return new Vector(-x,-y)
	}
	
	static area = function() {
		return x*y
	}
	
	static normalize = function() {
		return new Vector(x/magnitude(), y/magnitude())
	}
	
	static distance_to = function(_other) {
		return subtract(_other).magnitude()
	}
	
	// Vector operations
	
	static add = function(_other) {
		return new Vector(x + _other.x, y + _other.y)
	}
	
	static subtract = function(_other) {
		return add(_other.negative())
	}
	
	static multiply = function(_other) {
		if is_numeric(_other) {
			return multiply(new Vector(_other, _other))
		} else {
			return new Vector(_other.x * x, _other.y * y)
		}
	}
	
	static divide = function(_other) {
		if is_numeric(_other) {
			factor = 1.0 / _other
			return multiply(new Vector(factor, factor))
		} else {
			return new Vector(x/_other.x, y/_other.y)
		}
	}
	
	static copy = function() {
		return new Vector(x,y)
	}
	
	static up_add = function(_amount = 0) {
		return add(normalize().multiply(_amount))
	}
	
	static right_add = function(_amount = 0) {
		var _angle = angle() - 90 * (pi/180)
		var _normal = new Vector(cos(_angle), -sin(_angle))
		
		return add(_normal.multiply(_amount))
	}
	
	static is_equal = function(_other_vector) {
		return _other_vector.x == x && _other_vector.y == y
	}
	
	static linear_interpolate = function(_other, _weight = 1) {
		return new Vector(
			lerp(x, _other.x, _weight),
			lerp(y, _other.y, _weight)
		)
	}
}


function get_vector_from_magnitude_and_angle(_magnitude, _direction) {
	return new Vector(
		cos(_direction)*_magnitude,
		sin(_direction)*_magnitude
	)
}

function get_from_struct(_struct, _name, _default = noone) {
	return variable_struct_exists(_struct,_name) ? variable_struct_get(_struct,_name) : _default
}



function CameraView(_id, _position = new Vector(0,0)) constructor {

	id = _id
	position = _position
	size = undefined;
	
	// Setters
	
	static get_size = function () {
		return new Vector(camera_get_view_width(id), camera_get_view_height(id))
	}
	
	static get_position = function () {
		return new Vector(camera_get_view_x(id), camera_get_view_y(id))
	}
	
	// Getters
	
	static set_size = function(_size) {
		camera_set_view_size(id, _size.x, _size.y)
		size = _size
	}
	
	size = get_size()

	
	static set_position = function(_position) {
		camera_set_view_pos(id, _position.x, _position.y)
		position = _position
	}
	
	static step = function() {
		set_position(position)
		set_size(size)
	}
}

function SpriteDraw(
_spr_id,
_anchor_point = new Vector(.5,.5), _scale = 1, _position = new Vector(0,0), _rotation = 0, _alpha = 1) constructor {
	
	sprite_id = _spr_id
	position = _position
	rotation = _rotation
	scale = _scale
	anchor_point = _anchor_point
	alpha = _alpha
	
	/*if is_undefined(position) { position = DEFAULT_SPRITE_INFORMATION.position }
	if is_undefined(rotation) { rotation = DEFAULT_SPRITE_INFORMATION.rotation}
	if is_undefined(scale) { scale = DEFAULT_SPRITE_INFORMATION.scale }
	if is_undefined(anchor_point) { anchor_point = DEFAULT_SPRITE_INFORMATION.anchor_point }
	if is_undefined(alpha) { alpha = DEFAULT_SPRITE_INFORMATION.alpha }*/
	
	// Getters
	
	static get_size = function() {
		return new Vector(
			sprite_get_width(sprite_id) * scale,
			sprite_get_height(sprite_id) * scale
		)
	}
	
	static get_unscaled_size = function() {
		return new Vector(
			sprite_get_width(sprite_id),
			sprite_get_height(sprite_id)
		)
	}
	
	static get_anchored_position = function() {
		var _size = get_size().multiply(anchor_point)
		return position.subtract(_size)
	}
	
	// Methods
	
	static draw = function() {
		var _anchor_offset = get_unscaled_size().multiply(anchor_point)
		sprite_set_offset(sprite_id, _anchor_offset.x, _anchor_offset.y)
		draw_sprite_ext(sprite_id, 0, position.x, position.y, scale, scale, rotation, c_white, alpha)
	}
	
}

function Event() constructor {
	listeners = {}
	next_listener_id = -1
	
	function add_listener(_listener) {
		
		if !is_callable(_listener) {
			return noone
		}
		
		next_listener_id++
		variable_struct_set(listeners, next_listener_id, string(_listener))
		return next_listener_id
	}
	
	function add_listeners(_listeners) {
		var _names = struct_get_names(_listeners) 
		
		for(var _name_index = 0; _name_index < array_length(_names); _name_index++) {
			add_listener(variable_struct_get(_listeners, _names[_name_index]))
		}
	}
	
	
	static remove_listener = function(_listener_id) {
		variable_struct_set(listeners, string(_listener_id), undefined)
	}
	
	
	static fire = function(_args=[]) {
		var _listeners_ids = struct_get_names(listeners)
		
		for (var _index = 0; _index < array_length(_listeners_ids); _index++) {
			var _listener_id = _listeners_ids[_index]
			var _listener = variable_struct_get(listeners, _listener_id)
			
			if is_callable(_listener) {
				_listener(_args)
			}
		}
	}
}






