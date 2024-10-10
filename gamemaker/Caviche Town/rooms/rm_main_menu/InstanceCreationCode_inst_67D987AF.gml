width = 300
height = 64

text = "Unirse a servidor"

x = room_width*.5

on_pressed.add_listener(function(_args) {
	global.rooms.main_menu.url = global.rooms.main_menu.url_input.text
	if string_length(global.rooms.main_menu.url_input.text) > 0 {
		room_goto(rm_sandbox)
	}	
})

