extends Label

var base_y := 0.0
var speed := 3.0
var amplitude := 5.0

@onready var anim = $"../Score Anim"

var a = 255

func _ready() -> void:
	base_y = position.y
	await get_tree().create_timer(2).timeout

func _process(delta: float) -> void:
	position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude

func _physics_process(delta: float) -> void:
	text = str(GeneralVars.player_score)
	
	if GeneralVars.player_score < GeneralVars.score_update:
		GeneralVars.player_score += 25
