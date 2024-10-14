// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
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

		
		if shooting || equipping || gun_information == _information {
			return
		}
		
		gun_information = _information
		reloading = false
		timer = 0
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

	function shoot() {
		
		
		if gun_information == noone || character == noone || equipping {
			return
		}
		
		if gun_information.loaded_ammo <= 0 {
			gun_information.loaded_ammo = 0
			return
		}
		
		if reloading {
			reloading = false
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
			
			global.particle_manager.create_particle(_sprite, {
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
		
		timer += delta_time/MILLION
		
		if equipping {
			_added_rotation += (0 - _added_rotation) * timer/equipping_time
			
			if timer >= equipping_time {
				_added_rotation = 0
				equipping = false
			}
		}
		
		if gun_information == noone {
			shooting = false
			return
		}
		
		var _sprite_info = sprite_get_info(gun_information.sprite)
		
		
		if shooting || !can_shoot {
			
			subimage = timer/(_sprite_info.num_subimages/sprite_get_speed(gun_information.sprite)) * _sprite_info.num_subimages
			
			randomize()
			_added_rotation += get_direction()
		
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
				var _required_ammo =  gun_information.max_ammo - gun_information.loaded_ammo
				var _reloaded_ammo = 0
				
				if _current_ammo >= _required_ammo {
					_reloaded_ammo = _required_ammo
				} else if _current_ammo < _required_ammo && _current_ammo > 0 {
					_reloaded_ammo = _current_ammo
				}
				
				if _reloaded_ammo > gun_information.reload_ammo {
					_reloaded_ammo = gun_information.reload_ammo
				}
				
				character.backpack.set_ammo(gun_information.bullet_type, _current_ammo - _reloaded_ammo)
				gun_information.loaded_ammo += _reloaded_ammo
				
				if gun_information.loaded_ammo < gun_information.max_ammo && character.backpack.get_ammo(gun_information.bullet_type) > 0 {
					timer = 0
				} else {
					reloading = false
					can_shoot = true
				}

				
				show_debug_message("Reloaded: "+string(gun_information.loaded_ammo))
				show_debug_message("Ammo: "+string(_current_ammo - _reloaded_ammo))

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

