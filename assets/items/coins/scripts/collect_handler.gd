extends Area2D

@onready var pickup_anim = $"../../Texts/Score Anim"
@onready var coin_sprite = $"Coin Sprite"
@onready var timer_reset = $"../../Timers/reset_coin_pitch"

var base_y := 0.0
var speed := 1.0
var amplitude := 2.0

func _ready():
	Signals.pitch_reset_timer.connect(_timer_reset_pitch)
	base_y = position.y
	
func _process(delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude

func _on_body_entered(body: Node2D) -> void:
	var tween = create_tween()

	# anima quantidade de tempo
	var duration = 0.1  

	var target_position = body.position + Vector2(0, -10)
	tween.tween_property(self, "position", target_position, duration)

	# anima escala até desaparecer
	tween.parallel().tween_property(coin_sprite, "scale", Vector2(0,0), duration)

	# espera acabar
	await tween.finished

	# efeitos
	AudioPlayer.sfx_gold_coin_collect()
	GeneralVars.score_update += (100 * GeneralVars.pitch_score)
	pickup_anim.play("score_up")
	
	if GeneralVars.pitch_score < 1.5:
		GeneralVars.pitch_score += 0.1
		print(GeneralVars.pitch_score)
	
	timer_reset.start(3.0)
	
	queue_free()

func _timer_reset_pitch():
	GeneralVars.pitch_score = 1.0
