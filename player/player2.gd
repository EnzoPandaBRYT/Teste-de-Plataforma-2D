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
	if _state and _state != _StateMachine.JUMP:
		_movement() # Movimentação do Personagem
	if _jump_action:
		_change_state(_StateMachine.JUMP)
	elif _Input:
		_enterState("walking")
	else:
		_change_state(_StateMachine.IDLE)

func _jump() -> void:
	_enterState("jumping")
		
	if _Input and _jump_action == true:
		_movement()
	
	if _jump_action:
		_animated_sprite.play("jumping")
		
	
	if Input.is_action_pressed("crouch") and Input.is_action_just_pressed("use_power") and !is_on_floor():
		_change_state(_StateMachine.STOMP_CHARGE)
		stomp_charge = 0
	
	elif is_on_floor() and !_jump_action:
		_change_state(_StateMachine.IDLE)

func player_movement():
	# Pulo
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed
		
	
	if Input.is_action_just_released("jump"):
		velocity.y *= 0.5
		velocity.x = 0

	# Ataque
	if Input.is_action_pressed("attack") and is_on_floor():
		_change_state(_StateMachine.ATTACK_BASIC)

func _stomp_charge() -> void:
	_enterState("stomp_charge")
	
	if Input.is_action_pressed("use_power"):
		velocity.y = 0
		velocity.x = 0
		stomp_charge += get_process_delta_time()
		if stomp_charge >= 0.25:
			print("Stomp totalmente carregado!")
			_change_state(_StateMachine.ATTACK_STOMP)
	else:
		_change_state(_StateMachine.ATTACK_STOMP)
	
func _attack_stomp() -> void:
	_enterState("attack_stomp")
	velocity.y = 200 * (stomp_charge*10)
	
	if Input.is_action_just_pressed("jump"):
		_change_state(_StateMachine.JUMP)
	
	if is_on_floor():
		_animated_sprite.play("attack_stomp_ground")
		var animation_timer := 0.0
		while animation_timer < 0.25 and is_on_floor(): # Toca por 1 segundo
			print(animation_timer)
			animation_timer += get_process_delta_time()
			await get_tree().create_timer((animation_timer * stomp_charge)/1) # Aguarda o próximo frame
		_change_state(_StateMachine.IDLE)
	
func _basic_attack() -> void:
	_enterState("attack_basic")
