extends Character

var stomp_charge := 0.0

func _idle() -> void: # Estado Inerte
	_enterState("idle") # Nome da Animação que será tocada
	_stop_movement() # Anula qualquer movimento para 0
	
	if _Input: # Se tiver Input, então:
		_change_state(_StateMachine.WALK)
		
	if _jump_action:
		_change_state(_StateMachine.JUMP)
		

func _walk() -> void:
	_movement() # Movimentação do Personagem
	if _jump_action:
		_change_state(_StateMachine.JUMP)
	elif _Input:
		_enterState("walking")
	else:
		_change_state(_StateMachine.IDLE)

func _jump() -> void:
	_enterState("jumping")
	print(stomp_charge)
	if _Input: # Se tiver Input, então:
		_movement() # Movimentação do Personagem
	
	if _jump_action:
		_animated_sprite.play("jumping")
		await get_tree().create_timer(0.2).timeout
	
	if Input.is_action_pressed("crouch") and Input.is_action_just_pressed("use_power") and !is_on_floor():
		_change_state(_StateMachine.STOMP_CHARGE)
		stomp_charge = 0
	
	elif is_on_floor():
		_change_state(_StateMachine.IDLE)


func _stomp_charge() -> void:
	_enterState("stomp_charge")
	_animated_sprite.play("stomp_charge")
	
	if Input.is_action_pressed("use_power"):
		velocity.y = 0
		velocity.x = 0
		stomp_charge += get_process_delta_time()
		print(stomp_charge)
		if stomp_charge >= 1.0:
			print("Stomp totalmente carregado!")
			_change_state(_StateMachine.ATTACK_STOMP)
	else:
		velocity.y = 250 * (stomp_charge*5)
	
	if is_on_floor():
		_change_state(_StateMachine.IDLE)
	
func _attack_stomp() -> void:
	velocity.y = 250 * (stomp_charge*5)
	
	
