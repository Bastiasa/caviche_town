event_inherited()

character.sprites = global.characters_sprite_set.soldier02()
character.backpack.put_gun(get_uzi_information(), 0)

character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 80)
character.backpack.set_ammo(BULLET_TYPE.LIL_GUY, 80)


character.backpack.set_ammo(BULLET_TYPE.GRENADES, 2)

character.equipped_gun_manager.set_gun(character.backpack.guns[0])