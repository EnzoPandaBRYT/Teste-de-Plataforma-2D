class_name Character extends CharacterBody2D

@export var _speed := 100.0
@export var _jump_speed := -350.0

enum _StateMachine { IDLE, WALK, RUN, JUMP, SLIME_TRANSFORM, SLIME_IDLE, SLIME_WALK, SLIME_JUMP } # Determina todos os Estados possíveis

var _state : _StateMachine # Determina a variável como sendo do tipo "StateMachine (enum)" / O valor de _state determina qual função será executada no _physics_process
var _enter_state := true # Variável 

var locked = false
var redVel := true
var transforming := false
var slime = GeneralVars.slime

@onready var _animated_sprite = $anim

var _Input: float: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.get_axis("move_left", "move_right")
	
var _ReverseInput: float: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.get_axis("move_left", "move_right") * -1

var dir = (_ReverseInput * _Input) * -1

var _Crouch: bool: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.is_action_pressed("crouch")
	
var _Run: bool: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.is_action_pressed("run")

@warning_ignore("unused_private_class_variable")
var _jump_action: bool: # Sistema de Pulo
	get: return Input.is_action_just_pressed("jump")

func _physics_process(delta: float) -> void:
	match _state: # State machine que, quando encontra o estado, executa uma função
		_StateMachine.IDLE: _idle()
		_StateMachine.WALK: _walk()
		_StateMachine.RUN: _run()
		_StateMachine.JUMP: _jump()
		_StateMachine.SLIME_TRANSFORM: _slime_transform()
		_StateMachine.SLIME_IDLE: _slime_idle()
		_StateMachine.SLIME_WALK: _slime_walk()
		_StateMachine.SLIME_JUMP: _slime_jump()
	
	
	_reset_scene()
	_set_Gravity(delta) # Gravidade que usa o parâmetro "delta"
	player_movement() # Movimentação do personagem
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
func _walk() -> void: pass
func _run() -> void: pass
func _jump() -> void: pass
func _slime_transform() -> void: pass
func _slime_idle() -> void: pass
func _slime_walk() -> void: pass
func _slime_jump() -> void: pass

func _movement() -> void:
	if GeneralVars.in_cutscene:
		return

	if Input.is_action_pressed("run"):
		velocity.x = _Input * _speed * 1.5
	else:
		velocity.x = _Input * _speed # Coloca a velocidade do eixo X como o Input recebido (Fórmula na variável)
	
	# Flipa o personagem dependendo da direção que _Input recebe
	if _Input > 0:
		_animated_sprite.flip_h = false
	if _Input < 0:
		_animated_sprite.flip_h = true
		
	if !_Run:
		if dir > 0.8:
			_animated_sprite.speed_scale = dir
		elif dir < 0.8 && dir >= 0.4:
			_animated_sprite.speed_scale = 0.75
		else:
			_animated_sprite.speed_scale = 0.5

func _stop_movement() -> void:
	velocity.x = 0

func _slime_stop_movement() -> void:
	velocity.x = 0
	velocity.y = 0

func _set_Gravity(delta: float) -> void:
	if !is_on_floor():
		if !slime:
			velocity += get_gravity() * delta # Gravidade
		else:
			velocity += get_gravity() * delta * 1.25
		
func _reset_scene() -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
