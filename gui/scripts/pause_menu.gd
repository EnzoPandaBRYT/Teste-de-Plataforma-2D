extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	if $AnimationPlayer.animation_finished:
		$".".visible = false
	
func pause():
	$".".visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func getEsc():
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause_game") and get_tree().paused:
		resume()
		
func _process(delta: float) -> void:
	getEsc()
