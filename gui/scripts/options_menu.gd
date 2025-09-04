extends Control

#Sliders
@onready var masterSlider = $MasterVolume/HBoxContainer/masterSlider
@onready var sfxSlider = $SFXVolume/HBoxContainer/sfxSlider

#SFX dos botões
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")


func _ready():
	AudioPlayer.play_music_menu()
	#$Panel2/VBoxContainer/back.grab_focus()
	$AnimationPlayer.play("blur_transition")
	
	var audio_settings = GameConfig.load_audio_settings()
	masterSlider.value = min(audio_settings["masterVolume"], 1.0) * 100
	sfxSlider.value = min(audio_settings["sfxVolume"], 1.0) * 100
	
func _on_button_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/100))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))

# Salva o valor do Master Volume
func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameConfig.save_audio_settings("masterVolume", masterSlider.value / 100)
		
func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameConfig.save_audio_settings("sfxVolume", sfxSlider.value / 100)

# Transição ao entrar na cena acaba
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "blur_transition":
		$ColorRect.visible = false
