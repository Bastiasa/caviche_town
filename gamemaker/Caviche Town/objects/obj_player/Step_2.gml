/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

was_on_floor = is_on_floor

move_and_collide(velocity.x, velocity.y, obj_floor)

var _camera_target_position = position.subtract(camera.get_size().multiply(.5))

camera.position = camera.position.linear_interpolate(_camera_target_position, .08)
camera.position.y = 0

camera.step()