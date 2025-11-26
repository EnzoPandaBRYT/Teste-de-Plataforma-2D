extends EnemyStateMachine

@onready var anim = $anim
@onready var wall_detector = $anim/wall_detect
@onready var player_detector = $anim/player_detect
@onready var player = $"../../player"

var health = EnemyVars.bd_health

var point_1: float
var point_2: float

var directionX := 10.0

func _process(delta: float) -> void:
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
		player._apply_knockback()
	velocity.x = directionX
