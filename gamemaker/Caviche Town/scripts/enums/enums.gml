// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información


enum CHARACTER_STATE {
	MOVING_LEFT,
	MOVING_RIGHT,
	BRAKING,
	STANDING,
	FALLING,
	LANDING,
	JUMPING,
	DASHING,
	WALLSLIDE,
	WALLSLIDE_LEFT,
	WALLSLIDE_RIGHT,
	DEATH
}

enum INPUT {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
		
	JUMP,
	DASH,
	
	SHOOT,
	RELOAD,
	AIM
}

enum PARTICLE_ANIMATION {
	SCALE_DOWN,
	PHYSICS
}


enum BULLET_TYPE {
	LIL_GUY,
	MEDIUM,
	BIG_JOCK,
	SHELL,
	_SHELL_BULLET,
	ROCKET,
	GRENADES,
}

enum UDP_CLIENT_STATE {
	CONNECTING,
	CONNECTED,
	DISCONNECTED
}

enum CONTAINER_DISPOSITION {
	FREE,
	VERTICAL_LAYOUT,
	HORIZONTAL_LAYOUT
}