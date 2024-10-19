
character.backpack.max_guns = 4
character.backpack.guns = array_create(4, noone)
character.backpack.put_gun(get_rpg7_information(), 0)
character.backpack.put_gun(get_sniper_information(), 1)
character.backpack.put_gun(get_pistol_information(), 2)
character.backpack.put_gun(get_pump_information(), 3)

character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 300)
character.backpack.set_ammo(BULLET_TYPE.BIG_JOCK, 300)
character.backpack.set_ammo(BULLET_TYPE.ROCKET, 12)
character.team = "red"
character.sprites = global.characters_sprite_set.default_man()