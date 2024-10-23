// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function EquippedGunManager(_character = noone) constructor {
	
	gun_information = noone
	
	target_position = new Vector()
	_target_position = new Vector()
	_rotation = 0
	_added_rotation = 0
	
	character = _character
	
	audio_emitter = audio_emitter_create()
	
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
	
	playing_shoot_sound = noone
	playing_reload_sound = noone
	
	function free_audio_emitter() {
		if audio_emitter != noone && audio_emitter != undefined {
			if audio_emitter_exists(audio_emitter) {
				audio_emitter_free(audio_emitter)
			}
		}
	}

	function play_sound(_sound_id, _fallof_ref_distance, _fallof_max_distance, _fallof_factor = 1) {
		
		
		if !audio_emitter_exists(audio_emitter) {
			return
		}
		
		audio_emitter_falloff(audio_emitter, _fallof_ref_distance, _fallof_max_distance, _fallof_factor)
		
		return audio_play_sound_on(
			audio_emitter,
			_sound_id,
			false,
			3
		)
	}

	function stop_sound_instance(_instance_id) {
		if _instance_id != noone {
			if audio_is_playing(_instance_id) {
				audio_stop_sound(_instance_id)
			}
		}
	}
	
	function stop_shoot_sound() {
		stop_sound_instance(playing_shoot_sound)
		playing_shoot_sound = noone
	}
	
	function stop_reload_sound() {
		stop_sound_instance(playing_reload_sound)
		playing_reload_sound = noone
	}
	
	function set_gun(_information) {

		
		if shooting || equipping || gun_information == _information {
			return
		}
		
		stop_reload_sound()
		
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
		
		var _reload_sound = get_from_struct(gun_information, "reload_sound", undefined)
		
		if _reload_sound != undefined {
			playing_reload_sound = play_sound(_reload_sound, 2000, 5000, 1)
		}
		
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
			spr_reload_button()
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
		
		/*
		if !character._position_free(character.x + _bullet_position.x, character.y + _bullet_position.y) {
			return
		}
		*/
		
		if character._collision_point(character.x + _bullet_position.x, character.y + _bullet_position.y, obj_collider, false, false) != noone {
			return
		}
		
		if character.died {
			return
		}
		
		reloading = false
		
		stop_reload_sound()
		
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
		
		var _shoot_sound = get_from_struct(gun_information, "shoot_sound", undefined)
		
		if _shoot_sound != undefined {
			play_sound(_shoot_sound, 100, 1000, 1)
			
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
		_bullet.distance_damage_decrease = get_from_struct(gun_information, "distance_damage_decrease", 500)
		
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
		
		audio_emitter_position(audio_emitter, character.x, character.y, 0)
		
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
					
					var _reload_sound = get_from_struct(gun_information, "reload_sound", undefined)
		
					if _reload_sound != undefined {
						audio_play_sound_on(audio_emitter, _reload_sound, false, 1)
			
					}
					
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

