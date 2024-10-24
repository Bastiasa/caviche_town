// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function get_pistol_information() {
	return {
		name:"pistol",
		sprite: spr_pistol,
		sprite_unloaded: spr_pistol_unloaded,
		sprite_inventory: spr_pistol_inventory,
		
		scale:0.3,
		bullet_type: BULLET_TYPE.LIL_GUY,
		cooldown: 0.07,
		movement_weight: 0.3,
		distance: 16,
		muzzle_offset: new Vector(1, 6/41),
		dispersion:4,
		
		damage:24,
		
		
		drops_particle: true,
		dropped_particle_offset: new Vector(5/9, 2/6),
		dropped_particle_scale: 0.35,
		
		loaded_ammo:10,
		max_ammo:10,
		
		reload_ammo: 12,
		reload_time:1.5,
		
		is_auto: false,
		
		shoot_sound: snd_pistol_shoot,
		reload_sound: snd_pistol_reload,
		
		physics: {
			restitution: 0,
			linear_damping: 0.04,
			angular_damping: 0.1,
			friction: 1,
			density: 0.6,
			box_x:6,
			box_y:2,
			box_width:58 - 6,
			box_height:41 - 2
		}
	}
}

function get_pump_information() {
	return  {
		name:"pump",
		sprite: spr_pump,
		sprite_unloaded: spr_pump_unloaded,
		sprite_inventory: spr_pump_inventory,
		
		scale:1,
		bullet_type: BULLET_TYPE.SHELL,
		cooldown: 0.7,
		movement_weight: 0.06,
		distance: 24,
		muzzle_offset: new Vector(1, 3/13),
		dispersion:0,
		
		
		player_camera_shake: true,
		player_camera_shake_amount: 10,
		damage:152,
		
		drops_particle: true,
		dropped_particle_offset: new Vector(23/47, 4/13),
		dropped_particle_scale: 0.35,
		dropped_particle_sprite: spr_empty_shell_particle,

		loaded_ammo:5,
		max_ammo:5,
		
		reload_ammo: 1,
		reload_time:1.02,
		
		is_auto: false,
		
		reload_sound: snd_shotgun_reload,
		shoot_sound: snd_shotgun_shoot,
		
		physics: {
			restitution: 0.02,
			linear_damping: 0.04,
			angular_damping: 0.1,
			friction: 1,
			density: 0.6,
			box_x:0,
			box_y:0,
			box_width:47,
			box_height:13
		}
	}
}

function get_m16_information() {
	return {
		name:"m16",
		sprite: spr_m16,
		sprite_unloaded: spr_m16_unloaded,
		sprite_inventory: spr_m16_inventory,
		
		distance_damage_decrease: 400,
		
		view_distance: 520,

		scale:1,
		damage: 28,
		bullet_type: BULLET_TYPE.MEDIUM,
		cooldown: 1/5.5,
		movement_weight: 0.13,
		distance: 24,
		muzzle_offset: new Vector(1, 5/14),
		dispersion:4,
		
		drops_particle: true,
		dropped_particle_offset: new Vector(17/47, 4/14),
		dropped_particle_scale: 0.3,

		is_auto: true,
		
		//loaded_ammo:30,
		loaded_ammo:20,
		max_ammo:20,
		
		shoot_sound: snd_m16_shoot,
		reload_sound: snd_m16_reload,
		
		reload_ammo: 20,
		reload_time: 2.2,
		
		physics: {
			restitution: 0.1,
			linear_damping: 0.2,
			angular_damping: 0.1,
			friction: 2,
			density: 0.5,
			box_x:0,
			box_y:0,
			box_width:47,
			box_height:14
		}
	}	
}

function get_rpg7_information() {
	return {
		name:"rpg7",
		sprite: spr_rpg7,
		sprite_unloaded: spr_rpg7_unloaded,
		sprite_inventory: spr_rpg7_inventory,

		scale:1,
		damage: 100,
		bullet_type: BULLET_TYPE.ROCKET,
		cooldown: 0,
		movement_weight: 0.05,
		distance: 2,
		muzzle_offset: new Vector(49/62, 8/16),
		dispersion:0,
		
		player_camera_shake: true,
		player_camera_shake_amount: 18,
		
		drops_particle: false,

		is_auto: false,
		
		view_distance: 470,
		
		//loaded_ammo:30,
		loaded_ammo:1,
		max_ammo:1,
		
		shoot_sound: snd_rpg7_shoot,
		reload_sound: snd_rpg7_reload,
		
		reload_ammo: 1,
		reload_time: 2.69,
		
		physics: {
			restitution: 0,
			linear_damping: 0.1,
			angular_damping: 0.1,
			friction: 1000,
			density: 1,
			box_x:0,
			box_y:0,
			box_width: sprite_get_width(spr_rpg7),
			box_height: sprite_get_height(spr_rpg7)
		}
	}	
}

function get_hitman_bestfriend_information() {
	return {
		name:"hitman_bf",
		
		sprite: spr_hitman_bestfriend,
		sprite_unloaded: spr_hitman_bestfriend_unloaded,
		sprite_inventory: spr_hitman_bestfriend_inventory,
		
		distance_damage_decrease: 900,

		scale:.3,
		damage: 50,
		bullet_type: BULLET_TYPE.LIL_GUY,
		cooldown: 1,
		movement_weight: 1,
		distance: 10,
		muzzle_offset: new Vector(1, 6/41),
		dispersion:0,
		
		view_distance: 580,
		
		player_camera_shake: true,
		player_camera_shake_amount: 2,
		
		drops_particle: true,
		dropped_particle_sprite: spr_empty_cannon_particle,
		dropped_particle_scale: 0.37,
		dropped_particle_offset:  new Vector(5/9, 2/6),

		is_auto: false,
		
		loaded_ammo:10,
		max_ammo:10,
		
		reload_ammo: 10,
		reload_time: 2,
		
		physics: {
			restitution: 0.02,
			linear_damping: 0.2,
			angular_damping: 0.2,
			friction: 0.9,
			density: 1.8,
			box_x:6,
			box_y:2,
			box_width: sprite_get_width(spr_hitman_bestfriend) - 6,
			box_height: sprite_get_height(spr_hitman_bestfriend) - 2
		}
	}	
}

function get_sniper_information() {
	return {
		name:"sniper",
		sprite: spr_sniper,
		sprite_unloaded: spr_sniper_unloaded,
		sprite_inventory: spr_sniper_inventory,
		
		distance_damage_decrease: 300,
		
		view_distance: 800,

		scale:1,
		damage: 150,
		bullet_type: BULLET_TYPE.BIG_JOCK,
		cooldown: 2,
		movement_weight: 0.05,
		distance: 2,
		muzzle_offset: new Vector(1, 7/16),
		dispersion:1.4,
		
		player_camera_shake: true,
		player_camera_shake_amount: 8,
		
		drops_particle: true,
		dropped_particle_sprite: spr_empty_cannon_particle,
		dropped_particle_scale: 0.37,
		dropped_particle_offset: new Vector(19/63, 8/16),

		is_auto: false,
		
		loaded_ammo:5,
		max_ammo:5,
		
		shoot_sound: snd_sniper_shoot,
		reload_sound: snd_sniper_reload,
		
		reload_ammo: 5,
		reload_time: 2.8,
		
		physics: {
			restitution: 0.02,
			linear_damping: 0.04,
			angular_damping: 0.1,
			friction: 1,
			density: 0.6,
			box_x:0,
			box_y:0,
			box_width:63,
			box_height:16
		}
	}	
}

function get_uzi_information() {
	return {
		name:"uzi",
		sprite: spr_uzi,
		sprite_unloaded: spr_uzi_unloaded,
		sprite_inventory: spr_uzi_inventory,
		
		distance_damage_decrease: 200,
		
		view_distance: 500,

		scale:.7,
		damage: 17,
		bullet_type: BULLET_TYPE.LIL_GUY,
		cooldown: 0.07,
		movement_weight: 0.2,
		distance: 18,
		muzzle_offset: new Vector(1, 6/27),
		dispersion:10,
		
		player_camera_shake: false,
		player_camera_shake_amount: 0,
		
		drops_particle: true,
		dropped_particle_sprite: spr_empty_cannon_particle,
		dropped_particle_scale: 0.37,
		dropped_particle_offset: new Vector(14/41, 4/27),

		is_auto: true,
		
		loaded_ammo:32,
		max_ammo:32,
		
		shoot_sound: snd_uzi_shoot,
		reload_sound: snd_uzi_reload,
		
		reload_ammo: 32,
		reload_time: 2.5,
		
		physics: {
			restitution: 0.02,
			linear_damping: 0.04,
			angular_damping: 0.1,
			friction: .3,
			density: 0.6,
			box_x:0,
			box_y:0,
			box_width:27,
			box_height:27
		}
	}	
}