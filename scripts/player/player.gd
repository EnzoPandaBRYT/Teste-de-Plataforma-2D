extends CharacterBody2D

@export var _speed := 300.0
@export var _jump_speed := -400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # Gravidade
	
	
	player_movement()
	move_and_slide()
	
func player_movement():
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed
		
	# Input de direção
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
