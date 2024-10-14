
#macro MILLION 1000000

function Vector(_x = 0, _y = 0) constructor {
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
	
	static add_listener = function(_listener) {
		
		if !is_callable(_listener) {
			return noone
		}
		
		next_listener_id++
		variable_struct_set(listeners, next_listener_id, _listener)
		return next_listener_id
	}
	
	
	static remove_listener = function(_listener_id) {
		variable_struct_remove(listeners, _listener_id)
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


function EquippedGunManager(_character = noone) constructor {
	
	gun_information = noone
	
	target_position = new Vector()
	_target_position = new Vector()
	_rotation = 0
	_added_rotation = 0
	
	character = _character
	
	timer = 0
	
	shooting = false
	can_shoot = true
	
	reloading = false
	can_reload = true
	
	equipping = false
	equipping_time = 0.2

	subimage = 0
	
	events = {
		on_bullet_shooted: new Event()
	}

	
	function set_gun(_information) {
		
		if _information == noone {
			gun_information = noone
			return
		}
		
		if shooting || equipping || gun_information == _information {
			return
		}
		
		reloading = false
		
		timer = 0
		gun_information = _information
		equipping = true
		_added_rotation = -35
	}
	
	function reload() {
		
		if character == noone {
			return
		}
		
		if character.died {
			return
		}
		
		if gun_information == noone {
			return
		}
		
		if gun_information.loaded_ammo == gun_information.max_ammo || reloading || !can_reload || shooting || equipping {
			return
		}
		
		can_shoot = false
		
		if character.backpack.get_ammo(gun_information.bullet_type) <= 0 {
			return
		}
		
		show_debug_message("Reload started")
		
		timer = 0
		reloading = true
	}
	
	static get_direction = function() {
		return abs(_rotation) > 90 && abs(_rotation) < 270 ? -1 : 1
	}

	static shoot = function() {
		
		if gun_information == noone || character == noone || equipping {
			return
		}
		
		if gun_information.loaded_ammo <= 0 {
			gun_information.loaded_ammo = 0
			return
		}
		
		if !can_shoot {
			return
		}
		
		if shooting && !can_shoot {
			return
		}
		
		var _bullet_position = get_offset_position(gun_information.muzzle_offset)
		
		if is_nan(_bullet_position.x) || is_nan(_bullet_position.y) {
			return
		}
		
		if !character._position_free(character.x + _bullet_position.x, character.y + _bullet_position.y) {
			return
		}
		
		if character.died {
			return
		}
		
		reloading = false
		
		if gun_information.drops_particle && global.particle_manager != noone {
			
			var _particle_offset = gun_information.dropped_particle_offset
			var _velocity = new Vector(-get_direction()*160, -160)
			var _acceleration = new Vector(0, 981)
			
			var _position = get_offset_position(_particle_offset)
			
			var _sprite = get_from_struct(gun_information, "dropped_particle_sprite", spr_empty_cannon_particle)
			var _scale = get_from_struct(gun_information, "dropped_particle_scale", 1)
			
			global.particle_manager.create_particle(spr_empty_cannon_particle, {
				position: _position.add(character.position),
				min_lifetime: 0.5,
				max_lifetime: 0.5,
				min_scale:_scale,
				max_scale:_scale,
				animation_params: {
					velocity: _velocity,
					acceleration: _acceleration,
					fade_out:0.1
				}
			}, PARTICLE_ANIMATION.PHYSICS)
		}
		
		gun_information.loaded_ammo--
		
		shooting = true
		can_shoot = false
		timer = 0
		
		//show_debug_message(string_concat("Bullet position X: ", _bullet_position.x))
		//show_debug_message(string_concat("Bullet position Y: ", _bullet_position.y))

		var _bullet = instance_create_layer(character.x + _bullet_position.x, character.y + _bullet_position.y, "bullets", obj_bullet)
		
		randomize()
		
		_bullet.shooter = character
		_bullet.rotation = _rotation - _added_rotation + random_range(-gun_information.dispersion, gun_information.dispersion)
		_bullet.type = gun_information.bullet_type
		_bullet.damage = gun_information.damage
		
		events.on_bullet_shooted.fire([_bullet])
		
		if variable_struct_exists(global, "particle_manager") {
			_bullet.particle_manager = global.particle_manager
		}
		
		_bullet.init()
		
	}
	
	static get_offset_position = function(_offset = new Vector(0,0)) {
		if gun_information == noone {
			return
		}
		
		var _sprite_size = new Vector(
			sprite_get_width(gun_information.sprite),
			sprite_get_height(gun_information.sprite)
		)
		
		var _position = _target_position.copy()
		
		var _right_normal = get_vector_from_magnitude_and_angle(1, -degtorad(_rotation))
		var _up_normal = get_vector_from_magnitude_and_angle(1, -degtorad(_rotation + 90))
		
		var _y_scale = gun_information.scale
		
		if abs(_rotation) > 90 && abs(_rotation) < 270 {
			_y_scale = -_y_scale
		}
		
		_position = _position.add(_right_normal.multiply(gun_information.scale * _sprite_size.x * _offset.x))
		_position = _position.subtract(_up_normal.multiply(_sprite_size.y * _y_scale * _offset.y))
		
		return _position
	}
	
	static _draw = function() {
		
		var _centered_position = new Vector(
			target_position.x - character.x,
			target_position.y - character.y
		)
		
		var _sprite_size = new Vector(
			sprite_get_width(gun_information.sprite),
			sprite_get_height(gun_information.sprite)
		)
		
		var _next_rotation = _centered_position.angle() * (180/pi)
		var _distance = gun_information.distance + _sprite_size.x * gun_information.scale
		var _y_scale = gun_information.scale * get_direction()
		
		if _centered_position.magnitude() > _distance {
			_centered_position = _centered_position.normalize().multiply(_distance)
		}
		
		var _up_vector = get_vector_from_magnitude_and_angle(1, _rotation)
		var _right_vector = get_vector_from_magnitude_and_angle(1, _rotation-90*(pi/180))
		
		_centered_position = _centered_position.up_add(-gun_information.muzzle_offset.x*_sprite_size.x*gun_information.scale)
		_centered_position = _centered_position.right_add(-gun_information.muzzle_offset.y*_sprite_size.y*_y_scale)
		
		_target_position = _target_position.linear_interpolate(_centered_position, gun_information.movement_weight)
		_rotation = lerp_angle(_rotation, _next_rotation, gun_information.movement_weight)
		
		var _position = character.position.add(_target_position)
		
		var _sprite = gun_information.sprite
		
		if gun_information.loaded_ammo <= 0 {
			_sprite = gun_information.sprite_unloaded
		}
		
		draw_sprite_ext(
			_sprite,
			subimage,
			_position.x,
			_position.y,
			gun_information.scale,
			_y_scale,
			_rotation + _added_rotation,
			c_white,
			1
		)
	}
	
	static on_draw_event = function() {
		
		if gun_information == noone {
			shooting = false
			return
		}
		
		var _sprite_info = sprite_get_info(gun_information.sprite)
		
		timer += delta_time/MILLION
		
		if shooting || !can_shoot {
			
			subimage = timer/(_sprite_info.num_subimages/sprite_get_speed(gun_information.sprite)) * _sprite_info.num_subimages
			
			randomize()
			_added_rotation += random(2) * get_direction()
		
			if timer >= gun_information.cooldown {
				can_shoot = true
				_added_rotation = 0
			}
			
			if subimage >= _sprite_info.num_subimages - 1 {
				shooting = false
				subimage = _sprite_info.num_subimages - 1
				
				_added_rotation = 0
			}
		}
		
		if reloading {
			
			if timer >= gun_information.reload_time {
				
				var _current_ammo = character.backpack.get_ammo(gun_information.bullet_type)
				var _required_ammo = gun_information.max_ammo - gun_information.loaded_ammo
				var _reloaded_ammo = 0
				
				if _current_ammo >= _required_ammo {
					_reloaded_ammo = _required_ammo
				} else if _current_ammo < _required_ammo && _current_ammo > 0 {
					_reloaded_ammo = _current_ammo
				}
				
				character.backpack.set_ammo(gun_information.bullet_type, _current_ammo - _reloaded_ammo)
				gun_information.loaded_ammo += _reloaded_ammo
				
				reloading = false
				can_shoot = true
				
				show_debug_message("Reloaded: "+string(gun_information.loaded_ammo))
				show_debug_message("Ammo: "+string(_current_ammo - _reloaded_ammo))

			}
			
		}
		
		if equipping {
			
			_added_rotation += (0 - _added_rotation) * timer/equipping_time
			
			if timer >= equipping_time {
				_added_rotation = 0
				equipping = false
			}
		}
		
		if !shooting && !equipping && !reloading {
		
			if gun_information.loaded_ammo <= 0 {
				subimage = _sprite_info.num_subimages - 1
			} else {
				subimage = 0
			}
		}
		
		try {
			_draw()
		} catch(err) {
		
		}
	}
}





