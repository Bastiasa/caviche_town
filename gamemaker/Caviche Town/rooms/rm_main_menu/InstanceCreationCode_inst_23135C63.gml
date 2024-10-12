

width = 200
height = 200

spacing = 0
disposition = CONTAINER_DISPOSITION.HORIZONTAL_LAYOUT

function label01(_text) {
	var _label = create_child(obj_text_label)

	_label.text = _text
	_label.relative_width = .25
	_label.relative_height = 1
	_label.height = 40
}


label01("Hello world 1")
label01("Hello world 2")
label01("Hello world 3")
label01("Hello world 4")
