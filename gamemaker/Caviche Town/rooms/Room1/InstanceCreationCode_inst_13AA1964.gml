
character.backpack.guns = array_create(4, noone)
character.backpack.put_gun(get_rpg7_information(), 0)
character.backpack.put_gun(get_sniper_information(), 1)
character.backpack.put_gun(get_pistol_information(), 2)

character.team = "red"
character.sprites = global.characters_sprite_set.default_man()