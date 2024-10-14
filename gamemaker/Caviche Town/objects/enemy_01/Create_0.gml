event_inherited()

character.sprites = global.characters_sprite_set.soldier01()
character.backpack.put_gun(get_m1014_information(), 0)
character.backpack.set_ammo(BULLET_TYPE.SHELL, 200)
character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 40)
character.equipped_gun_manager.set_gun(character.backpack.guns[0])