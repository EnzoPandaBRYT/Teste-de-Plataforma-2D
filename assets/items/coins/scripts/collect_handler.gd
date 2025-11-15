extends Area2D

var base_y := 0.0
var speed := 1.0
var amplitude := 2.0

func _ready():
	base_y = position.y
	
func _process(delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		AudioPlayer.sfx_gold_coin_collect()
		queue_free()
