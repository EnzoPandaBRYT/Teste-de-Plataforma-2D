extends Node

var _ControllersConnected: float:
	get: return Input.get_connected_joypads().size()

var _ControllerInput: float:
	get: return Input.get_joy_axis(0, JOY_AXIS_LEFT_X)

# Game
var gameExit = false
var fullscreen_toggle = false

var current_scene := ""

var usingController = false
var can_detect_input = true
var detect_delay = 0.15

# Player
var lastDir = 0.0

var in_cutscene = false
var can_jump_cutscene = false
var can_move = true
var slime = false
var gameOver = false
var hasCore = false

var health = 100
var taking_damage = false

var allowTutorials = GameConfig.allowTutorials
var currentTutorial = ""

# Pontuação
var score_update = 0
var player_score = 0
var pitch_score = 1.0

# Velocidade
var runAcc = 1.0
var runMaxAcc = 1.6

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
	
func _input(event):
	if !can_detect_input:
		return
	
	if event is InputEventKey and event.pressed:
		usingController = false
		_start_cooldown()
	
	
	elif (event is InputEventJoypadButton and event.pressed) or event is InputEventJoypadMotion:
		usingController = true
		_start_cooldown()
	
	
	if get_tree().current_scene:
		if get_tree().current_scene.name != "options_menu":
			current_scene = get_tree().current_scene.name
			
func _start_cooldown():
	can_detect_input = false
	await get_tree().create_timer(detect_delay).timeout
	can_detect_input = true
