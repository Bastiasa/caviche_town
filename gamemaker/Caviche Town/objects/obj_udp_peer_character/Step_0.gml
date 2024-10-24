/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
character.x = lerp(character.x, pos_x, .4)
character.y = lerp(character.y, pos_y, .4)

if is_struct(character.equipped_gun_manager) {
	character.equipped_gun_manager.target_position.x = target_pos_x
	character.equipped_gun_manager.target_position.y = target_pos_y
}
