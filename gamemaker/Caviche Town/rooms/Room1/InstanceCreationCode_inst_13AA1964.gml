
character.team = "red"
character.sprites = global.characters_sprite_set.default_man()

character.backpack.put_gun(get_rpg7_information(), 0)
character.backpack.put_gun(get_rpg7_information(), 1)
character.backpack.set_ammo(BULLET_TYPE.ROCKET, 12)
character.backpack.set_ammo(BULLET_TYPE.GRENADES, 3)