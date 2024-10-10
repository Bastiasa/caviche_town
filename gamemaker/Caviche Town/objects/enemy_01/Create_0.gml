event_inherited()

character.backpack.put_gun(global.get_pistol_information(), 0)
character.backpack.set_ammo(BULLET_TYPE.LIL_GUY, 200)
character.backpack.set_ammo(BULLET_TYPE.MEDIUM, 40)
character.equipped_gun_manager.set_gun(character.backpack.guns[0])
