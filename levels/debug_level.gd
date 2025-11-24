extends Node2D

@onready var player = $player
@onready var load = $"Level Load/black-load"
@onready var level_load = $"Level Load"
@onready var ingame_menus = $ingame_menus

func _ready() -> void:
	ingame_menus.visible = true
	level_load.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music_tutorial()
	$AnimationPlayer.play("fade_in")

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		load.visible = false
		GeneralVars.in_cutscene = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		player._change_state(player._StateMachine.IDLE)
		GeneralVars.in_cutscene = false


func _on_reset_coin_pitch_timeout() -> void:
	Signals.pitch_reset_timer.emit()
