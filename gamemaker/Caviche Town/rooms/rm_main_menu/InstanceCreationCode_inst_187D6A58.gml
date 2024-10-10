width = 300
height = 64

text = "Crear servidor"

x = room_width*.5

on_pressed.add_listener(function(_args) {
	global.rooms.main_menu.url = ""
	room_goto(rm_sandbox)
})