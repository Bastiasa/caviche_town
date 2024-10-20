
character.backpack.put_gun(get_hitman_bestfriend_information(), 0)
character.backpack.put_gun(get_sniper_information(), 1)
character.backpack.put_gun(get_rpg7_information(), 2)

character.backpack.set_ammo(BULLET_TYPE.GRENADES, 3)

character.team = "red"
character.sprites = global.characters_sprite_set.default_man()