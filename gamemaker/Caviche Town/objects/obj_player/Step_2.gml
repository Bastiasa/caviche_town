/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


if character.died {
	create_blood_spot()
	camera_shakeness = 30
	
	death_timer += get_delta()
	
	if death_timer >= 3 {
		room_goto(rm_main_menu)
	}
	
} else {
	camera.update_position()
	
	camera.position.x  = clamp(camera.position.x, 0, room_width - camera.size.x)
	camera.position.y  = clamp(camera.position.y, 0, room_height - camera.size.y)
}


camera_shakeness = max(0, camera_shakeness - camera_shakeness_decrease * get_delta())
camera_shakeness = min(camera_shakeness, 50)

last_aim_gamepad_movement = get_gamepad_direction(
	global.gamepad_axis_input_keys.aim_x_movement,
	global.gamepad_axis_input_keys.aim_y_movement,
	false,
	last_aim_gamepad_movement
)

last_mouse_position = new Vector(mouse_x, mouse_y)