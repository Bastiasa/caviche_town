// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


function get_pistol_information() {
	return {
		name:"pistol",
		sprite: spr_pistol,
		sprite_unloaded: spr_pistol_unloaded,
		scale:2,
		bullet_type: BULLET_TYPE.LIL_GUY,
		cooldown: 1/ 6.75,
		movement_weight: 0.3,
		distance: 16,
		muzzle_offset: new Vector(1, 1/6*2),
		dispersion:4,
		
		damage:24,
		
		
		drops_particle: true,
		dropped_particle_offset: new Vector(5/9, 2/6),
		dropped_particle_scale: 0.35,
		
		//loaded_ammo:12,
		loaded_ammo:12,
		max_ammo:12,
		
		reload_ammo: 12,
		reload_time:1.5,
	}
}

function get_m1014_information() {
	return  {
		name:"m1014_shotgun",
		sprite: spr_m1014,
		sprite_unloaded: spr_m1014_unloaded,
		scale:1,
		bullet_type: BULLET_TYPE.SHELL,
		cooldown: 0.5,
		movement_weight: 0.06,
		distance: 24,
		muzzle_offset: new Vector(43/48, 4/17),
		dispersion:0,
		
		
		player_camera_shake: true,
		player_camera_shake_amount: 20,
		damage:100,
		
		drops_particle: true,
		dropped_particle_offset: new Vector(5/9, 2/6),
		dropped_particle_scale: 0.35,
		dropped_particle_sprite: spr_empty_shell_particle,

		loaded_ammo:7,
		max_ammo:7,
		
		reload_ammo: 1,
		reload_time:0.567,
	}
}

function get_m16_information() {
	return {
		name:"m16",
		sprite: spr_m16,
		sprite_unloaded: spr_m16_unloaded,

		scale:1,
		damage:30,
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
