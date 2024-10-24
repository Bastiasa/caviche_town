/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

positions = []
player = noone
end_timer = 0

function random_gun() {
	return array_choose([
		get_pistol_information(),
		get_pump_information(),
		get_m16_information(),
		get_sniper_information(),
		get_uzi_information(),
		get_rpg7_information()
	])
}

function random_skin() {
	var _name = array_choose(struct_get_names(global.characters_sprite_set))
	var _result = variable_struct_get(global.characters_sprite_set, _name)
	
	return _result()
}

function init() {
	
	var _position = array_choose(positions)
	
	var _player = instance_create_layer(_position[0], _position[1], "characters", obj_player)
	
	_player.character.sprites = random_skin()
	
	_player.character.backpack.put_gun(random_gun(), 0)
	_player.character.backpack.put_gun(random_gun(), 1)
	_player.character.backpack.put_gun(random_gun(), 2)
	
	
	randomize()
	
	_player.character.backpack.set_ammo(BULLET_TYPE.LIL_GUY, round(random_range(40, 80)))
	_player.character.backpack.set_ammo(BULLET_TYPE.MEDIUM, round(random_range(40, 80)))
	_player.character.backpack.set_ammo(BULLET_TYPE.BIG_JOCK, round(random_range(40, 80)))
	_player.character.backpack.set_ammo(BULLET_TYPE.SHELL, round(random_range(40, 80)))
	_player.character.backpack.set_ammo(BULLET_TYPE.ROCKET, round(random_range(2, 5)))
	_player.character.backpack.set_ammo(BULLET_TYPE.GRENADES, round(random_range(1, 3)))
	
	_player.character.team = "xdxd"
	player = _player
}