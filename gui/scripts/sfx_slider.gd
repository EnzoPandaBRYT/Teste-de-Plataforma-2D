extends HSlider

var editing := false

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		editing = !editing
	
	if editing:
		if event.is_action_pressed("move_left"):
			value -= 1
		if event.is_action_pressed("move_right"):
			value += 1
