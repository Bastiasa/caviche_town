/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

if type == BULLET_TYPE.ROCKET {
	var _explosion = instance_create_layer(x,y,layer,obj_explosion)
	
	_explosion.cause = shooter
	_explosion.radius = 64
	
	_explosion.init()
}