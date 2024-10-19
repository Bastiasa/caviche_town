/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

mask_index = -1

events = {
	on_character_hitted: new Event()
}

shooter = noone
type = noone

scale = 1
rotation = 0
position = new Vector(x,y)

start_x = x
start_y = y

to_destroy = false

lifetime = 2
timer = 0

start_position_x = x
start_position_y = y

damage = 0
distance_damage_decrease = 900

_speed = 0
vertical_speed = 0

particle_manager = noone


function apply_damage_to_target(_target) {
	
	var _distance = point_distance(_target.x, _target.y, start_position_x, start_position_y)
	var _result_damage = damage
			
	if  _distance > distance_damage_decrease {
		_result_damage = max(5, distance_damage_decrease/_distance * damage)
	}
	
	if type != BULLET_TYPE.ROCKET {
		_target.apply_damage(_result_damage, shooter)
	}
	
	events.on_character_hitted.fire([_target, _result_damage])
}

function init() {
	
	switch type {
	
		case BULLET_TYPE.LIL_GUY:
			sprite_index = spr_short_bullet
			_speed = 20
			
			scale = 1
			
			break
		
		case BULLET_TYPE.MEDIUM:
			sprite_index = spr_medium_bullet
			_speed = 30
			
			scale = 0.5
			break
			
		case BULLET_TYPE.SHELL:
			
			randomize()
			var _shell_bullets_count = round(random_range(6,10))
			
			repeat(_shell_bullets_count) {
				var _shell_bullet = instance_create_layer(x,y,layer, obj_bullet)
				
				randomize()
			
				var _angle = 18
				
				_shell_bullet.type = BULLET_TYPE._SHELL_BULLET
				_shell_bullet.rotation = rotation + random_range(-_angle, _angle)
				_shell_bullet.damage = damage/_shell_bullets_count
				_shell_bullet.shooter = shooter
				_shell_bullet.events.on_character_hitted.add_listeners(events.on_character_hitted.listeners)
				_shell_bullet.init()
			}
			

			
			instance_destroy(id)
			return
			break
			
		case BULLET_TYPE._SHELL_BULLET:
			sprite_index = spr_shell_bullet
			randomize()
			_speed = random_range(10, 15)
			scale = random_range(.3, .8)
			
			lifetime = random_range(0.12, 0.3)
			break
			
		case BULLET_TYPE.ROCKET:
			sprite_index = spr_rocket_bullet
			_speed = 6
			lifetime = 4
		break
		
		case BULLET_TYPE.BIG_JOCK: 
			sprite_index = spr_big_jock_bullet
			_speed = 40
			lifetime = 1
		break
	}
	
	speed = _speed * delta_time / MILLION * 100
	direction = rotation
	
	//position = position.add(new Vector(lengthdir_x(speed, direction), lengthdir_y(speed, direction)))
	
	x = position.x
	y = position.y
}

function create_particles(_start_x,_start_y,_end_x,_end_y, _steps = 10, _sprite = spr_bullet_particle) {
	
	var _position = new Vector(_start_x,_start_y)
	var _end = new Vector(_end_x,_end_y)
	
	var _difference = _end.subtract(_position)
	var _step = _difference.divide(_steps)
	
	for (var _index = 0; _index < _steps; _index++) {
		
		particle_manager.create_particle(
			_sprite,
			{
				position: _position.copy(),
				
				min_lifetime:0.1,
				max_lifetime:0.1,
				
				min_scale:0.3,
				max_scale:0.3,
				
				animation_params: {
					fade_out: 0.05
				}
			},
			
			PARTICLE_ANIMATION.SCALE_DOWN
		)
		
			_position = _position.add(_step)
	
	}
	
	delete _position
	delete _end
	delete _difference
	delete _step
}
	
