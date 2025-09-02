extends Control

@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")


func _ready():
	AudioPlayer.play_music_menu()
	#$Panel2/container/start.grab_focus()
	
func _on_focus_entered() -> void:
	#AudioPlayer.play_FX(sfxSelectNormal, -9.0)
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/debug_level.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/scenes/options_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit(910)

func _on_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)
