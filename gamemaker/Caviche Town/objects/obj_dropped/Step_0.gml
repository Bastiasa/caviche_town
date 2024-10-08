/// @description Inserte aquí la descripción
// Puede escribir su código en este editor
return
var _delta = delta_time / MILLION

if !place_meeting(x,y+1, obj_collider) {
	vertical_speed += 9.81 * _delta

} else {
	vertical_speed = 0
}

horizontal_speed = lerp(horizontal_speed, 0, 0.09)
move_and_collide(horizontal_speed*_delta*100,vertical_speed*_delta*100, obj_collider)


/*if place_meeting(x+horizontal_speed*_delta*100,y, all) {
	while !place_meeting(x+sign(horizontal_speed), y, all) {
		x += sign(horizontal_speed)
	}
	
	horizontal_speed = 0
}

if place_meeting(x,y+vertical_speed*_delta*100, all) {
	while !place_meeting(x, y+sign(vertical_speed), all) {
		y += sign(vertical_speed)
	}
	
	vertical_speed = 0
}*/

//x += horizontal_speed * _delta * 100
//y += vertical_speed * _delta * 100