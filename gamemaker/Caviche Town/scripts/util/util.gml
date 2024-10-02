
#macro MILLION 1000000


function Vector(_x,_y) constructor {
	x = _x
	y = _y
	
	// Vector properties
	
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

#macro DEFAULT_SPRITE_INFORMATION {anchor_point: new Vector(0,0),position:new Vector(0,0),rotation: 0,scale:1,alpha:1}


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

function Bone(_sprite_id, _parent = noone, _anchor_point = new Vector(.5,.5), _scale = 1, _position = new Vector(0,0), _rotation = 0, _alpha = 1) constructor {
	parent = _parent
	sprite = new SpriteDraw(_sprite_id, _anchor_point, _scale, _position, _rotation, _alpha)
	
	rotation = _rotation
	
	static step = function () {
		sprite.rotation = rotation
		
		
		if is_instanceof(parent, Bone) {
			var _parent_size =  parent.sprite.get_size()
			var _parent_position = parent.sprite.position
			
			sprite.position = _parent_position.add(_parent_position.normalize().multiply(_parent_size))
			sprite.rotation = rotation + parent.rotation
		}
		
		sprite.draw()

	}
}
