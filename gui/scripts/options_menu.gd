extends Control

@onready var slider = $Panel/HBoxContainer/HSlider
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
var actualValue = 5


func _ready():
	AudioPlayer.play_music_menu()
	$Panel2/VBoxContainer/back.grab_focus()
	
func _on_button_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")
	
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
