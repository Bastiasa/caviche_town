var _target_join = global.rooms.main_menu.url

if string_length(_target_join) > 0 {
	var _client_instance = instance_create_layer(0,0,"Instances",obj_udp_client)
	if !_client_instance.connect_to_server(_target_join, 6060) {
		room_goto(rm_main_menu)
	}
} else {
	var _server = instance_create_layer(0,0,"Instances",obj_udp_server)
	_server.init(6060, 4)
}