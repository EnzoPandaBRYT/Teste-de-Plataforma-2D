extends Control

@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
@onready var sfxStartSound = preload("res://sounds/sfx/Start-Sound.wav")
var animation_finished = false

func _ready():
	AudioPlayer.play_music_menu()
	#$Panel2/container/start.grab_focus()
	$AnimationPlayer2.play("blur_transition")

func _on_focus_entered() -> void:
	#AudioPlayer.play_FX(sfxSelectNormal, -9.0)
	pass

func _on_start_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	AudioPlayer.play_FX(sfxStartSound, -12.0)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/scenes/options_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit(910)

func _on_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://levels/debug_level.tscn")

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	animation_finished = true
	if anim_name == "blur_transition":
		$ColorRect2.visible = false
