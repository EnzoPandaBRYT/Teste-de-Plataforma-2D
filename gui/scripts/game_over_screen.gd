extends Control

@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
@onready var player = $"../../player"

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	visible = false

func resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioPlayer.music_normal()
	$AnimationPlayer.play_backwards("blur")
	get_tree().paused = false
	await get_tree().create_timer(0.3).timeout
	$".".visible = false
	
func game_over():
	visible = true
	$AnimationPlayer.play("blur")
	$background/VBoxContainer/exit.grab_focus()
	get_tree().paused = true
		
func _process(_delta: float) -> void:
	if GeneralVars.gameOver == true:
		game_over()
		GeneralVars.gameOver = false
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		AudioPlayer.music_reduce()

func _on_restart_pressed() -> void:
	resume()
	GeneralVars.player_score = 0
	GeneralVars.score_update = 0
	GeneralVars.can_jump_cutscene = false
	GeneralVars.pitch_score = 1.0
	GeneralVars.currentTutorial = ""
	get_tree().reload_current_scene()
	
func _on_exit_pressed() -> void:
	resume()
	GeneralVars.gameExit = true
	$"../../AnimationPlayer".play("game_over_exit")
	AudioPlayer.fade_to_music(1.8)
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")

func _on_button_focus_entered() -> void:
	if GeneralVars._ControllersConnected > 0:
		AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_button_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)
