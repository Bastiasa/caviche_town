/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

timer += delta_time / MILLION

if timer >= spawn_time {
	timer = 0
	
	randomize()
		
	var _create_gun = choose(true, false)
	
	var _x = random_range(10, room_width - 10)
	var _y = random_range(10, 40)
	
	if _create_gun {
		var _gun_information_getter = array_choose(guns)
		var _gun_information = _gun_information_getter()
		
		var _instance = instance_create_layer(_x,_y,layer, obj_dropped_gun)
		_instance.set_information(_gun_information)
	} else {
		
		var _type = array_choose(bullet_types)
		var _amount = round(random_range(3, 80))
		var _instance = instance_create_layer(_x, _y, layer, obj_dropped_ammo)
		
		_instance.type = _type
		_instance.amount = _amount
		_instance.load_sprite()
	}
}