extends Node2D

func _ready() -> void:
	AudioPlayer.play_music_level1()
	$ColorRect.visible = true
	$AnimationPlayer.play("fade_in")
