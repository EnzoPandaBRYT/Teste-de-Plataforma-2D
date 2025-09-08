extends Node

var _ControllersConnected: float:
	get: return Input.get_connected_joypads().size()

var _ControllerInput: float:
	get: return Input.get_joy_axis(0, JOY_AXIS_LEFT_X)

var gameExit = false
