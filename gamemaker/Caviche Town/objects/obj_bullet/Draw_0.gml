/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

var _delta = delta_time / MILLION

speed = _speed * _delta * 100

draw_sprite_ext(
	sprite_index,
	0,
	x,
	y,
	scale,
	scale,
	rotation,
	c_white,
	1
)



timer += delta_time / MILLION

if global.debugging && global.debugging_options.show_bullets_trayectory {
	draw_set_color(c_red)
	draw_line(x, y, start_x, start_y)
	draw_set_color(c_white)
}


var _direction = new Vector(lengthdir_x(_speed,rotation), lengthdir_y(_speed,rotation))
var _position = new Vector(x,y)
var _next_position = _position.add(_direction)

/*if place_meeting(_next_position.x, _next_position.y, obj_collider) {
		
	var _normal = _direction.normalize()
	
	while (!place_meeting(x + _normal.x, y + _normal.y, obj_collider)) {
		x += _normal.x
		y += _normal.y
	}
	
	_position = new Vector(x,y)
	_next_position = _position.copy()
	_speed = 0
	
	to_destroy = true
}*/

if particle_manager != noone {
	
	var _last_position = _position.subtract(_direction)
	
	create_particles(
		_last_position.x,
		_last_position.y,
		_position.x,
		_position.y,
		_speed * .2,
		type != BULLET_TYPE.ROCKET ? spr_bullet_particle : spr_dust_1
	)
	
	/*particle_manager.create_particle(spr_bullet_particle, {
		position:new Vector(x,y),
		min_scale:0.3,
		max_scale:0.3,
		min_lifetime:0.4,
		max_lifetime:0.4
	}, PARTICLE_ANIMATION.SCALE_DOWN)*/
	
	/*var _position = new Vector(x,y)
	var _direction = new Vector(
		lengthdir_x(speed, direction),
		lengthdir_y(speed, direction)
	)
	
	var _last_position = _position.subtract(_direction)
	var _particles_count = 10
	
	for (var _count = 0; _count < _particles_count; _count++) {
		particle_manager.create_particle(spr_bullet_particle, {
			position: _position,
		
			min_scale:.3,
			max_scale:.3,
		
			min_lifetime:0.23,
			max_lifetime:0.23
		
		}, PARTICLE_ANIMATION.SCALE_DOWN)
		
		var _distance = _position.subtract(_last_position).magnitude() / _particles_count +1
		
		_position = _position.subtract(_direction.normalize().multiply(_distance))
	}*/
}

if timer >= lifetime {
	to_destroy = true
}