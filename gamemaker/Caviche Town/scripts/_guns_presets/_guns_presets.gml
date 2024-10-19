// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function get_pistol_information() {
	return {
		name:"pistol",
		sprite: spr_pistol,
		sprite_unloaded: spr_pistol_unloaded,
		scale:0.3,
		bullet_type: BULLET_TYPE.LIL_GUY,
		cooldown: 1/ 6.75,
		movement_weight: 0.3,
		distance: 16,
		muzzle_offset: new Vector(57/58, 6/41),
		dispersion:4,
		
		damage:24,
		
		
		drops_particle: true,
		dropped_particle_offset: new Vector(5/9, 2/6),
		dropped_particle_scale: 0.35,
		
		loaded_ammo:10,
		max_ammo:10,
		
		reload_ammo: 12,
		reload_time:1.5,
	}
}

function get_pump_information() {
	return  {
		name:"pump",
		sprite: spr_pump,
		sprite_unloaded: spr_pump_unloaded,
		scale:1,
		bullet_type: BULLET_TYPE.SHELL,
		cooldown: 0.5,
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
	}
}

function get_m16_information() {
	return {
		name:"m16",
		sprite: spr_m16,
		sprite_unloaded: spr_m16_unloaded,

		scale:1,
		damage: 30,
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
		
		reload_ammo: 20,
		reload_time: 2.5
	}	
}

function get_rpg7_information() {
	return {
		name:"rpg7",
		sprite: spr_rpg7,
		sprite_unloaded: spr_rpg7_unloaded,

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

		is_auto: true,
		
		//loaded_ammo:30,
		loaded_ammo:1,
		max_ammo:1,
		
		reload_ammo: 1,
		reload_time: 3
	}	
}

function get_sniper_information() {
	return {
		name:"sniper",
		sprite: spr_sniper,
		sprite_unloaded: spr_sniper_unloaded,
		
		distance_damage_decrease: 1200,

		scale:1,
		damage: 60,
		bullet_type: BULLET_TYPE.BIG_JOCK,
		cooldown: 0,
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

		is_auto: true,
		
		loaded_ammo:1,
		max_ammo:1,
		
		reload_ammo: 1,
		reload_time: 2.8
	}	
}