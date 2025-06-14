class_name Character extends CharacterBody2D

@export var _speed := 200.0
@export var _jump_speed := -400.0

enum _StateMachine { IDLE, WALK, JUMP, STOMP_CHARGE, ATTACK_STOMP } # Determina todos os Estados possíveis

var _state : _StateMachine = _StateMachine.IDLE # Determina a variável como sendo do tipo "StateMachine (enum)" / O valor de _state determina qual função será executada no _physics_process
var _enter_state := true # Variável 

@onready var _animated_sprite = $anim

var _Input: float: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.get_axis("move_left", "move_right")

@warning_ignore("unused_private_class_variable")
var _jump_action: bool: # Sistema de Pulo
	get: return Input.is_action_pressed("jump")

func _physics_process(delta: float) -> void:
	
	match _state: # State machine que, quando encontra o estado, executa uma função
		_StateMachine.IDLE: _idle()
		_StateMachine.WALK: _walk()
		_StateMachine.JUMP: _jump()
		_StateMachine.STOMP_CHARGE: _stomp_charge()
		_StateMachine.ATTACK_STOMP: _attack_stomp()
		
	_set_Gravity(delta) # Gravidade que usa o parâmetro "delta"
	player_movement() # Movimentação do personagem
	move_and_slide()

func _enterState(animation: String) -> void:
	if _enter_state:
		_enter_state = false
		_animated_sprite.play(animation)


func _change_state(new_state: _StateMachine) -> void:
	if _state != new_state:
		_state = new_state
		_enter_state = true

func player_movement() -> void: pass

# Estados possíveis dos personagens
func _idle() -> void: pass
func _walk() -> void: pass
func _jump() -> void: pass
func _stomp_charge() -> void: pass
func _attack_stomp() -> void: pass

func _movement() -> void:
	velocity.x = _Input * _speed # Coloca a velocidade do eixo X como o Input recebido (Fórmula na variável)
	
	# Flipa o personagem dependendo do Input
	if _Input > 0:
		_animated_sprite.flip_h = false
	if _Input < 0:
		_animated_sprite.flip_h = true

func _stop_movement() -> void:
	velocity.x = 0

func _set_Gravity(delta: float) -> void:
	if !is_on_floor() and _state != _StateMachine.STOMP_CHARGE:
		velocity += get_gravity() * delta # Gravidade
