extends Node

var _ControllersConnected: float:
	get: return Input.get_connected_joypads().size()

var _ControllerInput: float:
	get: return Input.get_joy_axis(0, JOY_AXIS_LEFT_X)

var gameExit = false
var fullscreen_toggle = false

func _ready() -> void:
	#print(_ControllerInput)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen_toggle") and !fullscreen_toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_toggle = !fullscreen_toggle
	elif Input.is_action_just_pressed("fullscreen_toggle") and fullscreen_toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_toggle = !fullscreen_toggle
