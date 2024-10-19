character.backpack.put_gun(get_rpg7_information(), 0)
character.backpack.put_gun(get_m1014_information(), 1)
character.backpack.put_gun(get_pistol_information(), 2)

character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 300)
character.backpack.set_ammo(BULLET_TYPE.SHELL, 300)
character.backpack.set_ammo(BULLET_TYPE.ROCKET, 12)
character.team = "red"
character.sprites = global.characters_sprite_set.default_man()