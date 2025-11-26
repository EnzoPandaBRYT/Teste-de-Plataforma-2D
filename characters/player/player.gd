extends Character

@onready var anim = $anim
@onready var collision = $colission
@onready var hurt_box = $hurt_box
@onready var hit_box_collision = $hit_box/area
@onready var collision_morph = $collision_morph
@onready var raycast: RayCast2D = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown

func _ready() -> void:
	$collision_morph.play("RESET")
	hit_box_collision.disabled = true

func _idle() -> void: # Estado Inerte
	_enterState("idle") # Nome da Animação que será tocada
	
	if !GeneralVars.taking_damage:
		_stop_movement() # Anula qualquer movimento para 0
	
	if _Crouch and !_jump_action:
		_change_state(_StateMachine.CROUCH)
	
	if _Input and !slime: # Se tiver Input, então:
		_change_state(_StateMachine.WALK)
		
	if _jump_action and !slime:
		_change_state(_StateMachine.JUMP)
	
	if _Attack and GeneralVars.can_attack:
		_change_state(_StateMachine.ATTACK)
	
	if Input.is_action_just_pressed("slime_transform"):
		_change_state(_StateMachine.SLIME_TRANSFORM)

func _walk() -> void:
	
	if _Attack and GeneralVars.can_attack:
		_change_state(_StateMachine.ATTACK)
	
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
	
	elif _Input and redVel and !GeneralVars.taking_damage:
		_movement()
		
	if _OnWall:
		velocity.y = 0
		_change_state(_StateMachine.ON_WALL)

func _crouch() -> void:
	if Input.is_action_just_released("crouch"):
		$colission.shape.size.x = 9.0
		$colission.shape.size.y = 17.8
		$colission.position.y = -1.189
		
		_change_state(_StateMachine.IDLE)
	else:
		crouching()
		$colission.shape.size.x = 13.0
		$colission.shape.size.y = 15.25
		$colission.position.y = 0.1
		
		if _jump_action:
			set_collision_mask_value(5, false)
			await get_tree().create_timer(0.3).timeout
			set_collision_mask_value(5, true)
		
		if GeneralVars.hasCore:
			pass
		else:
			_enterState("crouch")

func _attack() -> void:
	GeneralVars.can_attack = false
	_movement()
	anim.play("attack")
	hit_box_collision.disabled = false
	attack_cooldown_timer.start(0.5)

func _on_wall() -> void:
	_enterState("idle")
	
	# Verifica se o jogador não está mais na parede
	if !_OnWall:
		_change_state(_StateMachine.WALK)
	
	# Tira o jogador da parede se o Input for na direção contrária
	if _Input == lastDir * -1 or Input.is_action_just_pressed("crouch"):
		velocity.x += 25 * (lastDir * -1)
	
	if _Input != lastDir:
		velocity.y += 0.005

	
	if Input.is_action_just_pressed("jump"):
		AudioPlayer.sfx_wall_jump()
		if facing == 0:
			facing = 1 * lastDir
		else:
			facing *= -1
		wall_jumping = true
		velocity.x += 100 * (lastDir * -1)
		velocity.y += _jump_speed/1.1
		
		if facing * -1 > 0:
			_animated_sprite.flip_h = false
			raycast.target_position.x = 7
		if facing * -1 < 0:
			raycast.target_position.x = -7
			_animated_sprite.flip_h = true

func _slime_transform() -> void:
	transforming = true
	
	if slime == false:
		_animated_sprite.play("slime_transform")
		collision_morph.play("player-to-slime")
	else:
		_animated_sprite.play_backwards("slime_transform")
		collision_morph.play_backwards("player-to-slime")
		
	

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
	
	if GeneralVars.gameExit or GeneralVars.in_cutscene or GeneralVars.gameOver:
		_stop_movement()
		if !slime:
			_state = _StateMachine.IDLE
		else:
			_state = _StateMachine.SLIME_TRANSFORM
		# Reset da caixa de colisão IDLE
		$colission.shape.size.x = 9.0
		$colission.shape.size.y = 17.8
		$colission.position.y = -1.189
	
	# Pulo
	if Input.is_action_just_pressed("jump") and !_Crouch and !transforming and !GeneralVars.in_cutscene and is_on_floor():
		AudioPlayer.sfx_jump_normal()
		if !slime:
			velocity.y = _jump_speed
		else:
			velocity.y = _jump_speed * 1.30

	if Input.is_action_just_released("jump") and redVel and !_OnWall:
		if !slime:
			velocity.y *= 1.1
			velocity.x *= 0.5
		else:
			velocity.y *= 1.05
			velocity.x *= 0.75
	
	if wall_jumping and !is_on_floor() and !_jump_action:
		velocity.x = 100 * facing * -1
	elif is_on_floor():
		GeneralVars.taking_damage = false
		wall_jumping = false
		facing = 0
	
	if _Input:
		lastDir = _Input
		
	if _Input > 0: # Direita
		raycast.target_position.x = 7
		hit_box_collision.position.x = 7
	if _Input < 0: # Esquerda
		raycast.target_position.x = -8
		hit_box_collision.position.x = -8
	if raycast.is_colliding():
		_OnWall = true
	else:
		_OnWall = false

func slime_movement() -> void:
	velocity.x = _Input * (_speed/1.5) # Coloca a velocidade do eixo X como o Input recebido (Fórmula na variável)
	
	# Flipa o personagem dependendo da direção que _Input recebe
	if _Input > 0:
		anim.flip_h = false
	if _Input < 0:
		anim.flip_h = true

func crouching() -> void:
	velocity.x = _Input * (_speed/1.25)
	
	# Flipa o personagem dependendo da direção que _Input recebe
	if _Input > 0:
		anim.flip_h = false
	if _Input < 0:
		anim.flip_h = true


func _on_animation_finished() -> void:
	if anim.animation == "slime_transform":
		if !slime:
			slime = true
			transforming = false
			_change_state(_StateMachine.SLIME_IDLE)
		else:
			slime = false
			transforming = false
			_change_state(_StateMachine.IDLE)
			
	if anim.animation == "attack":
		_change_state(_StateMachine.IDLE)
		hit_box_collision.disabled = true

func _apply_knockback(strength_x := 100, strength_y = -150) -> void:
	GeneralVars.taking_damage = true
	
	velocity.y = strength_y
	velocity.x = -lastDir * strength_x
	await get_tree().create_timer(1).timeout


func _on_attack_cooldown_timeout() -> void:
	GeneralVars.can_attack = true
