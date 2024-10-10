/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

events = {
	on_character_hitted: new Event()
}

shooter = noone
type = noone

scale = 1
rotation = 0
position = new Vector(x,y)

to_destroy = false

lifetime = 2
timer = 0

start_position_x = x
start_position_y = y

damage = 0

_speed = 0

particle_manager = noone

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
	}
	
	speed = _speed * delta_time / MILLION * 100
	direction = rotation
	
	//position = position.add(new Vector(lengthdir_x(speed, direction), lengthdir_y(speed, direction)))
	
	x = position.x
	y = position.y
}

function create_particles(_start_x,_start_y,_end_x,_end_y, _steps = 10) {
	
	var _position = new Vector(_start_x,_start_y)
	var _end = new Vector(_end_x,_end_y)
	
	var _difference = _end.subtract(_position)
	var _step = _difference.divide(_steps)
	
	for (var _index = 0; _index < _steps; _index++) {
		
		particle_manager.create_particle(
			spr_bullet_particle,
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
	
