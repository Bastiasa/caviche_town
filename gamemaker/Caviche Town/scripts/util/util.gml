
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

function lerp_angle(_from, _to, _weight) {
	_from = _from mod 360
	_to = _to mod 360
	
	var _difference = (_to - _from) mod 360
	
	if _difference > 180 {
		_difference -= 360	
	}
	
	return (_from + _difference * _weight) mod 360
}

function draw_progress_circle(_x,_y,_progress, _scale = 1, _alpha = 1) {
	var _info = sprite_get_info(spr_progress_circle)
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
	)
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

function ParticleEmitterManager() constructor {
	
	particles = []
	
	static create_particle = function(_sprite = spr_dust_1,  _data = {}, _animation_type = PARTICLE_ANIMATION.SCALE_DOWN) {
		randomize()
		
		var _position = new Vector()
		_position = get_from_struct(_data, "position", _position)
		
		var _animation_params = get_from_struct(_data, "animation_params", {})

		var _min_scale = get_from_struct(_data, "min_scale", 1)
		var _max_scale = get_from_struct(_data, "max_scale", 1)

		var _min_lifetime = get_from_struct(_data, "min_lifetime", 1)
		var _max_lifetime = get_from_struct(_data, "max_lifetime", 1)
		
		var _min_rotation = get_from_struct(_data, "min_rotation", 0)
		var _max_rotation = get_from_struct(_data, "max_rotation", 0)
		
		var _scale = random_range(_min_scale, _max_scale)
		var _lifetime = random_range(_min_lifetime, _max_lifetime)
		var _rotation = random_range(_min_rotation, _max_rotation)
		
		
		var _particle = {
			sprite: _sprite,
			position: _position,
			
			_lifetime:_lifetime,
			lifetime: _lifetime,
			
			_scale: _scale,
			scale: _scale,
			
			_rotation:_rotation,
			rotation:_rotation,
			
			animation_type: _animation_type,
			animation_params: _animation_params,
			
			sprite_info: sprite_get_info(_sprite)
		}
		
		array_push(particles, _particle)
		return _particle
	}
	

	
	static _draw_particle = function(_index) {
		
		var _particle_information = particles[_index]
		var _delta = delta_time / MILLION
		
		if _particle_information.lifetime <= 0 {
			array_delete(particles, _index, 1)
			return
		}

		_particle_information.lifetime -= _delta
		

		
		if _particle_information.animation_type == PARTICLE_ANIMATION.SCALE_DOWN {
			_particle_information.scale = (_particle_information.lifetime/_particle_information._lifetime)*_particle_information._scale
		} else if _particle_information.animation_type == PARTICLE_ANIMATION.PHYSICS {
			var _velocity = get_from_struct(_particle_information.animation_params, "velocity")
			var _acceleration = get_from_struct(_particle_information.animation_params, "acceleration")
			
			var _angular_velocity = get_from_struct(_particle_information.animation_params, "angular_velocity")
			var _angular_acceleration = get_from_struct(_particle_information.animation_params, "angular_acceleration")
			
			if _angular_velocity != noone {
				_particle_information.rotation += _angular_velocity * _delta
			}
			
			if _angular_velocity != noone && _angular_acceleration != noone {
				_particle_information.animation_params.angular_velocity += _angular_acceleration * _delta
			}
			
			if _velocity != noone {
				_particle_information.position.x += _velocity.x * _delta
				_particle_information.position.y += _velocity.y * _delta
			}
			
			if _acceleration != noone {
				_velocity.x += _acceleration.x * _delta
				_velocity.y += _acceleration.y * _delta
			}
		}
		
		var _alpha = 1
		var _fade_out_duration = get_from_struct(_particle_information.animation_params, "fade_out", noone)
		var _fade_in_duration = get_from_struct(_particle_information.animation_params, "fade_in", noone)
		
		if _fade_in_duration != noone {
			if _particle_information.lifetime > _particle_information._lifetime - _fade_in_duration {
				_alpha = (_particle_information._lifetime-_particle_information.lifetime)/_fade_in_duration
			}
		}
		
		if _fade_out_duration != noone {
			
			if _particle_information.lifetime <= _fade_out_duration {
				_alpha = _particle_information.lifetime/_fade_out_duration
			}
			
		}
		
		var _subimages_count = _particle_information.sprite_info.num_subimages
		var _subimage = round(_subimages_count * (1-(_particle_information.lifetime/_particle_information._lifetime)))
	
		draw_sprite_ext(
			_particle_information.sprite,
			min(_subimages_count - 1, _subimage),
			_particle_information.position.x,
			_particle_information.position.y,
			_particle_information.scale,
			_particle_information.scale,
			_particle_information.rotation,
			c_white,
			_alpha
		)
		
	}
	
	static on_draw_event = function() {
		var _delta = delta_time / MILLION
		
		for (var _particle_index = 0; _particle_index < array_length(particles); _particle_index++) {
			_draw_particle(_particle_index)
		}
		
	}
}

function CharacterBackpackManager(_character = noone) constructor {
	lil_guys = 0
	medium_bullets = 0
	big_jocks = 0
	rockets = 0
	
	max_lil_guys = 500
	max_medium_bullets = 500
	max_big_jocks = 500
	max_rockets = 12
	
	max_guns = 3
	guns = array_create(max_guns, noone)

	function first_busy_slot(_offset = 0) {
		
		var _result = -1
		
		for(var _slot = _offset; _slot < max_guns; _slot++) {
			if guns[_slot] != noone {
				_result = _slot
				break
			}
		}
		
		return _result
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
		if array_length(guns) < max_guns {
			array_push(guns, _information)
			return true
		}
		
		return false
	}
	
	function remove_gun(_index) {
		guns[_index] = noone
	}
	
	static get_ammo = function(_type) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: return lil_guys
			break
			case BULLET_TYPE.MEDIUM: return medium_bullets
			break
			case BULLET_TYPE.BIG_JOCK: return big_jocks
			break
			case BULLET_TYPE.ROCKET: return rockets
			break
			default: return noone
			break
		}
	}
	
	static get_max_ammo = function(_type) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: return max_lil_guys
			break
			case BULLET_TYPE.MEDIUM: return max_medium_bullets
			break
			case BULLET_TYPE.BIG_JOCK: return max_big_jocks
			break
			case BULLET_TYPE.ROCKET: return max_rockets
			break
			default: return noone
			break
		}
	}
		
	static set_ammo = function(_type, _new_ammo) {
		switch _type {
			case BULLET_TYPE.LIL_GUY: lil_guys = clamp(_new_ammo, 0, max_lil_guys); break
			case BULLET_TYPE.MEDIUM: medium_bullets = clamp(_new_ammo, 0, max_medium_bullets); break
			case BULLET_TYPE.BIG_JOCK: big_jocks = clamp(_new_ammo, 0, max_big_jocks); break
			case BULLET_TYPE.ROCKET: rockets = clamp(_new_ammo, 0, max_rockets); break
			default: return false; break
		}
		
		return true
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
		
		timer += delta_time/MILLION
		
		if shooting || !can_shoot {
			var _sprite_info = sprite_get_info(gun_information.sprite)
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
		
		try {
			_draw()
		} catch(err) {
		
		}
	}
}


function is_player(_posible_player) {
	return _posible_player != noone && _posible_player.object_index == obj_character && _posible_player.player != noone
}

function is_teammate(_character, _team) {
	return _character != noone && string_lower(_team) == string_lower(_character.team)
}

global.debugging = true

global.debugging_options = {
	show_enemies_raycast: true,
	show_enemies_floor_dot: true,
	show_characters_aim_dot: true,
	show_enemies_distance_to_target: true,
}

