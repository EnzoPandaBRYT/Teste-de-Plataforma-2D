extends Control

@onready var animationPlayer1 = $"MainMenu/AnimationPlayer"
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
@onready var sfxStartSound = preload("res://sounds/sfx/Start-Sound.wav")
var animation_finished = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GeneralVars.gameExit = false
	AudioPlayer.play_music_menu()
	_anim()
	
func _anim():
	animationPlayer1.play("fade_in")
	
func _on_focus_entered() -> void:
	if GeneralVars._ControllersConnected > 0:
		AudioPlayer.play_FX(sfxSelectNormal, -9.0)


func _on_start_pressed() -> void:
	$MainMenu/canvas/blur.visible = true
	$MainMenu/canvas/black.visible = true
	animationPlayer1.play("fade_out")
	AudioPlayer.play_FX(sfxStartSound, -12.0)
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://levels/tutorial.tscn")

func _on_options_pressed() -> void:
	$section.play("change_options")
	if GeneralVars._ControllersConnected > 0:
		$Options/Panel2/VBoxContainer/back.grab_focus()

func _on_exit_pressed() -> void:
	get_tree().quit(910)

func _on_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished = true
	if anim_name == "fade_in":
		$MainMenu/canvas/blur.visible = false
		$MainMenu/canvas/black.visible = false
		if Input.get_connected_joypads().size() > 0:
			$"MainMenu/Panel2/container/start".grab_focus()
			
