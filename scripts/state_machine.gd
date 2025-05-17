class_name Character extends CharacterBody2D

@export var speed := 300.0
@export var jump_speed := -400.0

enum StateMachine { IDLE, WALKING }

var state : StateMachine = StateMachine.IDLE
var enter_state : bool = true

@onready var animated_sprite = $anim

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # Gravidade
	
	match state:
		StateMachine.IDLE: _idle()
		StateMachine.WALKING: _walk()
	
	player_movement()
	move_and_slide()

func player_movement():
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	# Input de direção
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _enter_state(animation: String) -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play(animation)


func _change_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		enter_state = true



func _idle() -> void: pass
func _walk() -> void: pass
