extends Node2D

@onready var player = $player

func _ready() -> void:
	AudioPlayer.play_music_level1()
	$AnimationPlayer.play("fade_in")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		player._change_state(player._StateMachine.IDLE)
