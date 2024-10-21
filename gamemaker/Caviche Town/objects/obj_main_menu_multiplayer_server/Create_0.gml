/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

server_socket = instance_find(obj_udp_server, 0)
server_socket.init()


back_button = create_canvas_button("Volver", .5, .5, 300, 100)

back_button.offset_x = .5
back_button.offset_y = .5

back_button.events.on_mouse_click.add_listener(function(){change_to_spawner(obj_main_menu_multiplayer_menu, "multiplayer")})
