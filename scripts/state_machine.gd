class_name Character extends CharacterBody2D

@export var _speed := 300.0
@export var _jump_speed := -400.0

enum _StateMachine { IDLE, WALK, JUMP } # Determina todos os Estados possíveis

var _state : _StateMachine = _StateMachine.IDLE # Determina a variável como sendo do tipo "StateMachine (enum)"
var _enter_state := true # Variável 

@onready var _animated_sprite = $anim

var _Input: float:
	get: return Input.get_axis("move_left", "move_right") * _speed

var _jump_action: bool:
	get: return Input.is_action_just_pressed("jump")

func _physics_process(delta: float) -> void:
	
	match _state:
		_StateMachine.IDLE: _idle()
		_StateMachine.WALK: _walk()
		_StateMachine.JUMP: _jump()
	
	_set_Gravity(delta)
	player_movement()
	move_and_slide()

func player_movement():
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed
		
	print(_jump_action)

func _enterState(animation: String) -> void:
	if _enter_state:
		_enter_state = false
		_animated_sprite.play(animation)


func _change_state(new_state: _StateMachine) -> void:
	if _state != new_state:
		_state = new_state
		_enter_state = true



func _idle() -> void: pass
func _walk() -> void: pass
func _jump() -> void: pass

func _movement() -> void:
	velocity.x = _Input # Coloca a velocidade do eixo X como o Input recebido (Fórmula na variável)
	
	# Flipa o personagem dependendo do Input
	if _Input > 0:
		_animated_sprite.flip_h = false
	if _Input < 0:
		_animated_sprite.flip_h = true

func _stop_movement() -> void:
	velocity.x = 0

func _set_Gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # Gravidade
