/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

vertical_speed = 0
horizontal_speed = 0

y_scale = 1
x_scale = 1

rotation = 0
angular_speed = 0

image_speed = 0

function spawn_action_particle() {
	if global.particle_manager != noone {
	
		var _color = c_blue
	
		global.particle_manager.create_particle(spr_dropped_object_grabbed_particle, {
		
			position: new Vector(x,y),
		
			min_scale: .5,
			max_scale: .5,
		
			min_lifetime:1,
			max_lifetime:1,
			
			alpha:0.25,
		
			color: _color,
		
			animation_params: {
				fade_out: 0.1,
				fade_in	:0.06	
			}

		})
	}
}