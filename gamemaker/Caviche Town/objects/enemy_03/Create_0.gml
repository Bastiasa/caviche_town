event_inherited()

character.sprites = global.characters_sprite_set.hitman()
aiming_weight = 1

character.backpack.put_gun(get_hitman_bestfriend_information(), 0)

character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 80)


character.backpack.set_ammo(BULLET_TYPE.GRENADES, 2)

character.equipped_gun_manager.set_gun(character.backpack.guns[0])