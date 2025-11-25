extends CharacterBody2D

@export var _speed := 100.0
@export var _jump_speed := -350.0

enum _StateMachine { IDLE} # Determina todos os Estados possíveis

var _state : _StateMachine # Determina a variável como sendo do tipo "StateMachine (enum)" / O valor de _state determina qual função será executada no _physics_process
var _enter_state := true # Variável 

var facing = 0.0

@onready var _animated_sprite = $anim

func _physics_process(delta: float) -> void:
	match _state: # State machine que, de acordo com o Enum, executa uma função
		_StateMachine.IDLE: _idle()
	
	#_set_Gravity(delta) # Gravidade que usa o parâmetro "delta"
	move_and_slide()

func _enterState(animation: String) -> void: # Em suma, toca a animação que coloca lá no player.gd
	if _enter_state:
		_enter_state = false
		_animated_sprite.play(animation)


func _change_state(new_state: _StateMachine) -> void:
	if _state != new_state:
		_state = new_state
		_enter_state = true

func player_movement() -> void: pass
func slime_movement() -> void: pass

# Estados possíveis dos personagens
func _idle() -> void: pass

func _movement() -> void:
	if GeneralVars.in_cutscene:
		return

func _stop_movement() -> void:
	velocity.x = 0

func _set_Gravity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta * 1.25
