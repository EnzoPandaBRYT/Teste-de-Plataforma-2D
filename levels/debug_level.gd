extends Node2D

@onready var player = $player
@onready var load = $"CanvasLayer2/black-load"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music_level1()
	$AnimationPlayer.play("fade_in")

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		load.visible = false
		GeneralVars.in_cutscene = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		player._change_state(player._StateMachine.IDLE)
		GeneralVars.in_cutscene = false
