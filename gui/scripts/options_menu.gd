extends Control

@onready var slider = $Panel/HBoxContainer/VolumeSlider
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
var actualValue = 0


func _ready():
	AudioPlayer.play_music_menu()
	#$Panel2/VBoxContainer/back.grab_focus()
	$AnimationPlayer.play("blur_transition")
	
	var audio_settings = GameConfig.load_audio_settings()
	slider.value = min(audio_settings.master_volume, 1.0) * 100
	
func _on_button_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")
	
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/100))
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "blur_transition":
		$ColorRect.visible = false


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	GameConfig.save_audio_settings("volume_db", slider.value / 100)
