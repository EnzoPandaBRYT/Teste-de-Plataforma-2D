extends EnemyStateMachine

@onready var anim = $anim
@onready var wall_detector = $anim/wall_detect
@onready var player_detector = $anim/player_detect
@onready var player = $"../../player"
@onready var hurt_box = $anim/hurt_box
@onready var player_hit_box = $"../../player/hit_box"

var health = EnemyVars.bd_health

var point_1: float
var point_2: float

var directionX := 10.0

func _process(delta: float) -> void:
	
	if health <= 0:
		EnemyVars.bd_taking_damage
		queue_free()
	
	print(EnemyVars.bd_taking_damage)
	if GeneralVars.in_cutscene:
		return
	
	if wall_detector.is_colliding():
		if directionX > 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
		directionX *= -1
		wall_detector.target_position.x *= -1
		player_detector.target_position.x *= -1
	
	if player_detector.is_colliding():
		player._apply_knockback(100, -200)
	
	if !EnemyVars.bd_taking_damage:
		velocity.x = directionX
	
	if hurt_box.overlaps_area(player_hit_box):
		if !EnemyVars.bd_taking_damage:
			EnemyVars.bd_taking_damage = true
			apply_knockback()
			return
	
func apply_knockback(strength_x := 40, strength_y = 0) -> void:
	velocity.x = player.lastDir * strength_x
	take_damage()
	await get_tree().create_timer(0.2).timeout
	EnemyVars.bd_taking_damage = false

func take_damage():
	health -= 25
	await get_tree().create_timer(1).timeout
