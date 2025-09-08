extends Character

@onready var anim = $anim

var stomp_charge := 0.0
var transforming := false

func _idle() -> void: # Estado Inerte
	_enterState("idle") # Nome da Animação que será tocada
	_stop_movement() # Anula qualquer movimento para 0

	if _Input: # Se tiver Input, então:
		_change_state(_StateMachine.WALK)
		
	if _jump_action and !_Crouch:
		_change_state(_StateMachine.JUMP)
	
	if _jump_action and _Crouch:
		set_collision_mask_value(5, false)
		await get_tree().create_timer(0.3).timeout
		set_collision_mask_value(5, true)
	
	if Input.is_action_just_pressed("slime_transform"):
		_change_state(_StateMachine.SLIME_TRANSFORM)


	
		

func _walk() -> void:
	if _state != _StateMachine.JUMP:
		_movement() # Movimentação do Personagem
		if _Run:
			$anim.speed_scale = 2.0
		else:
			$anim.speed_scale = 1.0
	if _jump_action and !_Crouch or !is_on_floor():
		_change_state(_StateMachine.JUMP)
	elif _Input:
		_enterState("walking")
	else:
		_change_state(_StateMachine.IDLE)
	
	if _jump_action and _Crouch:
		set_collision_mask_value(5, false)
		await get_tree().create_timer(0.3).timeout
		set_collision_mask_value(5, true)

func _jump() -> void:
	_enterState("jumping")
		
	if _Input and redVel:
		_movement()
	
	if _jump_action:
		_animated_sprite.play("jumping")
	
	elif is_on_floor() and !_jump_action:
		_change_state(_StateMachine.IDLE)
		redVel = true

func _slime_transform() -> void:
	_enterState("slime_transform")
	
	if slime == false:
		print("Slime Falso")
		transforming = true
		_animated_sprite.play("slime_transform")
	else:
		print("Slime Verdadeiro")
		transforming = false
		_animated_sprite.play_backwards("slime_transform")

func _slime_idle() -> void:
	_slime_movement()
	
	if Input.is_action_just_pressed("slime_transform"):
		_change_state(_StateMachine.SLIME_TRANSFORM)
	
func _on_anim_animation_finished() -> void:
	if _state == _StateMachine.SLIME_TRANSFORM and transforming:
		_change_state(_StateMachine.SLIME_IDLE)
		slime = true
	elif _state == _StateMachine.SLIME_TRANSFORM and !transforming:
		_change_state(_StateMachine.IDLE)
		slime = false

func player_movement():
	if GeneralVars.gameExit:
		_change_state(_StateMachine.LOCKED)
		velocity.y = 0
		velocity.x = 0
	
	var dir = (_ReverseInput * _Input) * -1
	# Pulo
	if Input.is_action_just_pressed("jump") and !_Crouch and is_on_floor():
		if !slime:
			velocity.y = _jump_speed
		else:
			velocity.y = _jump_speed * 1.20

	if Input.is_action_just_released("jump") and redVel:
		if !slime:
			velocity.y *= 1.1
			velocity.x *= 0.5
		else:
			velocity.y *= 1.05
			velocity.x *= 0.75
			
	if !_Run:
		if dir > 0.8:
			anim.speed_scale = dir
		elif dir < 0.8 && dir >= 0.4:
			anim.speed_scale = 0.75
		else:
			anim.speed_scale = 0.5

func _locked():
	if !is_on_floor():
		_enterState("jumping")
	else:
		_enterState("idle")
	
