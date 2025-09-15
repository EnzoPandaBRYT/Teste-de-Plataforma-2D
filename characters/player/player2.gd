extends Character

@onready var anim = $anim
@onready var collision = $colission
@onready var collision_morph = $collision_morph

var stomp_charge := 0.0

func _ready() -> void:
	$collision_morph.play("RESET")

func _idle() -> void: # Estado Inerte
	_enterState("idle") # Nome da Animação que será tocada
	_stop_movement() # Anula qualquer movimento para 0

	if _Input and !slime: # Se tiver Input, então:
		_change_state(_StateMachine.WALK)
		
	if _jump_action and !_Crouch and !slime:
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
			anim.speed_scale = 1.5
		else:
			anim.speed_scale = 1.0
	
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
	
	
	
	if _jump_action or _jump_action and _Input:
		anim.play("jumping")
	
	elif is_on_floor() and !_jump_action:
		_change_state(_StateMachine.IDLE)
		redVel = true
	
	elif _Input and redVel:
		_movement()

func _slime_transform() -> void:
	transforming = true
	
	if slime == false:
		_animated_sprite.play("slime_transform")
		collision_morph.play("player-to-slime")
	else:
		_animated_sprite.play_backwards("slime_transform")
		collision_morph.play_backwards("player-to-slime")
		
func _on_slime_animation_finished() -> void:
	if anim.animation == "slime_transform":
		if !slime:
			slime = true
			transforming = false
			_change_state(_StateMachine.SLIME_IDLE)
			print("ERRO 1")
		else:
			print("ERRO 2")
			slime = false
			transforming = false
			_change_state(_StateMachine.IDLE)

func _slime_idle() -> void:
	_enterState("slime_idle")
	_stop_movement()
	
	if _jump_action:
		_change_state(_StateMachine.SLIME_JUMP)
	
	elif _Input:
		_change_state(_StateMachine.SLIME_WALK)
	
	if Input.is_action_just_pressed("slime_transform"):
		_change_state(_StateMachine.SLIME_TRANSFORM)
	
func _slime_walk() -> void:
	slime_movement()
	
	if _jump_action:
		_change_state(_StateMachine.SLIME_JUMP)
	
	elif _Input and !is_on_wall():
		_enterState("slime_walk")
	
	else:
		_change_state(_StateMachine.SLIME_IDLE)
		
func _slime_jump() -> void:
	_enterState("slime_jump_act_idle")
	slime_movement()
	
	if !is_on_floor() and !_Input:
		anim.play("slime_jump_mid_idle")
	elif !is_on_floor() and _Input:
		anim.play("slime_jump_mid_mov")
	else:
		anim.play_backwards("slime_jump_act_idle")
		_change_state(_StateMachine.SLIME_IDLE)

func player_movement():
	
	if GeneralVars.gameExit or GeneralVars.in_cutscene:
		_stop_movement()
		_state = _StateMachine.IDLE
		
	# Pulo
	if Input.is_action_just_pressed("jump") and !_Crouch and !transforming and !GeneralVars.in_cutscene and is_on_floor():
		if !slime:
			velocity.y = _jump_speed
		else:
			velocity.y = _jump_speed * 1.30

	if Input.is_action_just_released("jump") and redVel:
		if !slime:
			velocity.y *= 1.1
			velocity.x *= 0.5
		else:
			velocity.y *= 1.05
			velocity.x *= 0.75
			

func slime_movement() -> void:
	velocity.x = _Input * (_speed/1.5) # Coloca a velocidade do eixo X como o Input recebido (Fórmula na variável)
	
	# Flipa o personagem dependendo da direção que _Input recebe
	if _Input > 0:
		anim.flip_h = false
	if _Input < 0:
		anim.flip_h = true
