extends Control

@onready var animationPlayer1 = $"Main Menu/AnimationPlayer"
@onready var animationPlayer2 = $"Main Menu/AnimationPlayer2"
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
@onready var sfxStartSound = preload("res://sounds/sfx/Start-Sound.wav")
var animation_finished = false

func _ready():
	AudioPlayer.play_music_menu()
	animationPlayer1.play("fade_in")
	GeneralVars.gameExit = false
	await get_tree().create_timer(1.0).timeout
	$"Main Menu/ColorRect2".queue_free()

func _on_focus_entered() -> void:
	if GeneralVars._ControllersConnected > 0:
		AudioPlayer.play_FX(sfxSelectNormal, -9.0)


func _on_start_pressed() -> void:
	animationPlayer1.play("fade_out")
	AudioPlayer.play_FX(sfxStartSound, -12.0)
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://levels/debug_level.tscn")

func _on_options_pressed() -> void:
	$section.play("change_options")

func _on_exit_pressed() -> void:
	get_tree().quit(910)

func _on_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)
	

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	animation_finished = true
	if anim_name == "blur_transition":
		$"Main Menu/ColorRect2".visible = false
		if Input.get_connected_joypads().size() > 0:
			$"Main Menu/Panel2/container/start".grab_focus()
