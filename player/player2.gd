extends Character

func _idle() -> void: # Estado Inerte
	_enterState("idle") # Entra no estado "Idle"
	_stop_movement() # Anula qualquer movimento para 0
	
	if _Input: # Se tiver Input, então:
		_change_state(_StateMachine.WALK)
		_movement() # Movimentação do Personagem
		
	if _jump_action:
		_change_state(_StateMachine.JUMP)
		

func _walk() -> void:
	
	if _jump_action:
		_change_state(_StateMachine.JUMP)
	elif _Input:
		_enterState("walking")
	else:
		_change_state(_StateMachine.IDLE)

func _jump() -> void:
	_enterState("jumping")
	
	if _Input: # Se tiver Input, então:
		_movement() # Movimentação do Personagem
	
	if _jump_action:
		_animated_sprite.play("jumping")
		velocity.y = _jump_speed
		await get_tree().create_timer(0.2).timeout
	
	elif is_on_floor():
		_change_state(_StateMachine.IDLE)
