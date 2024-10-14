// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información

function ParticleEmitterManager() constructor {
	
	particles = []
	
	static create_particle = function(_sprite = spr_dust_1,  _data = {}, _animation_type = PARTICLE_ANIMATION.SCALE_DOWN) {
		randomize()
		
		var _position = new Vector()
		_position = get_from_struct(_data, "position", _position)
		
		var _color = get_from_struct(_data, "color", c_white)
		var _alpha = get_from_struct(_data, "alpha", 1)
		
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
			color: _color,
			alpha: _alpha,
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
		
		var _alpha = _particle_information.alpha
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
			_particle_information.color,
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

global.particle_manager = new ParticleEmitterManager()