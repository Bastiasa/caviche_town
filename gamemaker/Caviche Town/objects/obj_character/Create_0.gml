/// @description Insert description here
// You can write your code in this editor

sprites = global.characters_sprite_set.default_man()

team = ""
particle_manager = global.particle_manager
sprite_info = sprite_get_info(sprite_index)

events = {
	on_damage:new Event(),
	on_died:new Event()
}

timer = 0
timers = {
	on_wallslide_dust_timer:0,
	on_land_dust_timer:0,
	on_dash_dust_timer:0
}

controller = noone

_scale = 4
scale = new Vector(_scale, _scale)

current_state = CHARACTER_STATE.STANDING

backpack = new CharacterBackpackManager(self)
equipped_gun_manager = new EquippedGunManager(self)

position = new Vector(x,y)
velocity = new Vector(0,0)

horizontal_movement = 0


_normal_gravity = 9.81
_wallslide_gravity = 3.8
_gravity = _normal_gravity

deceleration = 5

walk_velocity = 4
walk_acceleration = 30

on_air_velocity = 3
on_air_acceleration = 10
air_deceleration = .3

acceleration = walk_acceleration
max_velocity = walk_velocity

was_on_floor = false
is_on_floor = false

jump_power = 5 //300
jump_coldown_timer = 0
jump_coldown_end = 0.15

coyote_time = 0
coyote_time_end = 0.14

// Dash variables

is_dashing = false
dash_speed = 7
on_dash_velocity = noone
dash_direction = noone
dash_cooldown_timer = 0
dashing_end = 0.2
dash_cooldown_end = dashing_end + 1

walljump_power = jump_power * .6

current_sprite_timer = 0

last_y_velocity = velocity.y

died = false
hp = 100
max_hp = 100

image_yscale = _scale
image_xscale = _scale

function is_character_teammate(_other) {
	return is_teammate(_other, team)
}

function create_dropped_gun(_gun_information) {
	
	if _gun_information == noone {
		return
	}
	
	var _sprite_size = get_sprite_size()

	var _dropped_gun = instance_create_layer(x,y-_sprite_size.y*.5, layer, obj_dropped_gun)
			
	_dropped_gun.sprite_index = _gun_information.sprite
	_dropped_gun.gun_information = _gun_information
	_dropped_gun.vertical_speed = -3
	_dropped_gun.horizontal_speed = sign(random_range(-1, 1)) * 3
	_dropped_gun.x_scale = _gun_information.scale
	_dropped_gun.y_scale = _gun_information.scale
			
	_dropped_gun.y -= sprite_get_width(_dropped_gun.sprite_index) * _gun_information.scale
	
	return _dropped_gun
}

function create_dropped_ammo(_type, _amount) {
	
	if _amount == 0 {
		return
	}
	
	var _sprite_size = get_sprite_size()
	var _dropped_ammo = instance_create_layer(x,y-_sprite_size.y*.5,layer,obj_dropped_ammo)
	
	_dropped_ammo.type = _type
	_dropped_ammo.amount = _amount
	
	_dropped_ammo.vertical_speed = -3
	_dropped_ammo.horizontal_speed = sign(random_range(-1, 1)) * 3
	
	_dropped_ammo.load_sprite()
	
	return _dropped_ammo
}

function drop_ammo(_type, _amount) {
	
	if _amount == all {
		var _result = create_dropped_ammo(_type, backpack.get_ammo(_type))
		backpack.set_ammo(_type, 0)
		return _result
	} else {
		
		var _current_ammo = backpack.get_ammo(_type)
		var _dropped_amount = 0
		
		if _current_ammo < _amount {
			_dropped_amount = _current_ammo
		} else {
			_dropped_amount = _amount
		}
		
		backpack.set_ammo(_type, _current_ammo - _dropped_amount)
		return create_dropped_ammo(_type, _dropped_amount)
	}


}

function apply_damage(_damage, _from = noone) {
	
	events.on_damage.fire([_damage, _from])

	if died {
		return
	}
	
	hp -= _damage
	
	if hp <= 0 {
		hp = 0
		died = true
		
		array_foreach(backpack.guns, create_dropped_gun)
		
		drop_ammo(BULLET_TYPE.LIL_GUY, all)
		drop_ammo(BULLET_TYPE.MEDIUM, all)
		drop_ammo(BULLET_TYPE.BIG_JOCK, all)
		drop_ammo(BULLET_TYPE.ROCKET, all)
		drop_ammo(BULLET_TYPE.SHELL, all)
		drop_ammo(BULLET_TYPE.GRENADES, all)
		
		equipped_gun_manager.set_gun(noone)
		
		backpack.clear_guns()
		backpack.clear_ammo()
		
		events.on_died.fire()
	}
}

function spawn_dust_particle(_x,_y, _min_scale,_max_scale,_min_lifetime,_max_lifetime,_animation_params = {fade_out:0.4, fade_in:0.1}) {
	
	if global.particle_manager != noone {
		var _sprite = spr_dust_1

		global.particle_manager.create_particle(
			_sprite,
			{
				position: new Vector(_x,_y),
				min_scale:_min_scale,
				max_scale:_max_scale,
				max_lifetime:_max_lifetime,
				min_lifetime:_min_lifetime,
				animation_params:_animation_params
			},
			
			PARTICLE_ANIMATION.SCALE_DOWN
		)
	}
}

function _position_free(_x,_y) {
	var _result = position_empty(_x,_y)
	return _result || position_meeting(_x,_y, obj_character)
}

function _collision_line_list(_x1,_y1,_x2,_y2,_obj,_prec,_notme,_list,_ordered) {
	return collision_line_list(_x1,_y1,_x2,_y2,_obj,_prec,_notme,_list,_ordered)
}

function check_collisions() {
	
	var _velocity = velocity.multiply(get_delta() * 100)
	
	if meeting_right(_velocity.x) {
		while !meeting_right(sign(_velocity.x)) {
			x += sign(_velocity.x)
		}
	
		velocity.x = 0
	}

	if meeting_bottom(_velocity.y) {
		while !meeting_bottom(sign(_velocity.y)) {
			y += sign(_velocity.y)
		}
		
		last_y_velocity = velocity.y
		velocity.y = 0
	}
}

function walljump() {
	if !is_on_floor && !died {
		function spawn_on_walljump_particle(_xoffset = 0) {
			particle_manager.create_particle(spr_dust_1, {
				position: new Vector(x+_xoffset,y),
				min_lifetime:0.9,
				max_lifetime:1.2,
				min_scale: 0.8,
				max_scale: 0.9
			})
		}
	
		if meeting_left() && !is_moving_right() {
			velocity.y = -walljump_power
			velocity.x = acceleration*.5
			spawn_on_walljump_particle(get_sprite_size().x * .5)
		}

		if meeting_right() && !is_moving_left() {
			velocity.y = -walljump_power
			velocity.x = -acceleration*.5
		
			spawn_on_walljump_particle(get_sprite_size().x * .5)
		}
	}
}

function get_delta() {
	return delta_time / MILLION
}

function get_sprite_size() {
	return new Vector(sprite_get_width(sprite_index)* scale.x, sprite_get_height(sprite_index)* scale.y)
}

function set_sprite_index_if_isnt(_index) {
	if sprite_index != _index {
		sprite_index = _index
		sprite_info = sprite_get_info(_index)
		
		image_index = 0
		current_sprite_timer = 0
	}
}

function brake() {
	velocity.x = lerp(velocity.x, 0, deceleration * get_delta())
}

function jump() {
	
	if died {
		return
	}
	
	if !is_on_floor && coyote_time >= coyote_time_end {
		walljump()
		return
	}
	
	if is_dashing && dash_cooldown_timer < dashing_end {
		return
	}	
	
	if jump_coldown_timer > 0 && jump_coldown_timer < jump_coldown_end {
		return
	}
	
	coyote_time = coyote_time_end
	velocity.y = -jump_power
}

function dash(_direction = new Vector()) {
	if !died && !is_dashing && current_state != CHARACTER_STATE.WALLSLIDE_LEFT && current_state != CHARACTER_STATE.WALLSLIDE_RIGHT {
		is_dashing = true
		dash_cooldown_timer = 0
		
		dash_direction = _direction
		dash_direction = get_vector_from_magnitude_and_angle(abs(sign(dash_direction.magnitude()))*dash_speed, -dash_direction.angle())
		
		if dash_direction.magnitude() == 0 {
			is_dashing = false
		} else {		
			coyote_time = coyote_time_end + 1
		}
	}
}

function update_direction() {
	if velocity.x > 0 && velocity.x > 0.1 {
		current_state = CHARACTER_STATE.MOVING_RIGHT
		scale.x = _scale
	} else if velocity.x < 0 && velocity.x < -0.1{
		current_state = CHARACTER_STATE.MOVING_LEFT
		scale.x = -_scale
	} else {
		current_state = CHARACTER_STATE.STANDING
	}
	
	if velocity.y > 0 {
		current_state = CHARACTER_STATE.FALLING
	} else if velocity.y < 0 {
		current_state = CHARACTER_STATE.JUMPING
	}
}

function on_fall_ended(_impact_velocity) {
	show_debug_message(_impact_velocity)
}


function is_moving_left() {
	return velocity.x < 0
}

function is_moving_right() {
	return velocity.x > 0
}

function is_moving_up() {
	return velocity.y < 0
}

function want_go_left() {
	return horizontal_movement < 0
}

function want_go_right() {
	return horizontal_movement > 0
}


function meeting_left(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x - _added, y, _obj_index)
}

function meeting_right(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x + _added, y, _obj_index)
}
	
function meeting_bottom(_added = 1, _obj_index = obj_collider) {
	return place_meeting(x, y+_added, _obj_index)
}
	
function meeting_top(_added = 0, _obj_index = obj_collider) {
	return place_meeting(x, y - _added, _obj_index)
}

