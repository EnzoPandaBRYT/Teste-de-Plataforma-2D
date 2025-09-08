extends Node

#Sliders
@onready var masterSlider = $MasterVolume/HBoxContainer/masterSlider
@onready var sfxSlider = $SFXVolume/HBoxContainer/sfxSlider

#Botões
@onready var fullscreenButton = $MasterVolume2/HBoxContainer/CheckBox
#SFX dos botões
@onready var sfxSelectNormal = preload("res://sounds/sfx/Select.mp3")
@onready var sfxChanged = preload("res://sounds/sfx/sfxSoundSlider.wav")
@onready var sfxSliderSound = preload("res://sounds/sfx/Glitch Sound Effect.mp3")

func _ready():
	var audio_settings = GameConfig.load_audio_settings()
	var video_settings = GameConfig.load_video_settings()
	masterSlider.value = min(audio_settings["masterVolume"], 1.0) * 100
	sfxSlider.value = min(audio_settings["sfxVolume"], 1.0) * 100
	
	if GameConfig.config.get_value("video", "fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreenButton.button_pressed = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreenButton.button_pressed = false
func _on_button_focus_entered() -> void:
	if GeneralVars._ControllersConnected > 0:
		AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_button_mouse_entered() -> void:
	AudioPlayer.play_FX(sfxSelectNormal, -9.0)

func _on_back_pressed() -> void:
	$"../section".play_backwards("change_options")

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
	AudioPlayer.play_FX(sfxSliderSound, 0.0)

# Transição ao entrar na cena acaba
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "blur_transition":
		$"../Main Menu/ColorRect".visible = false
		if GeneralVars._ControllersConnected > 0:
			$Panel2/VBoxContainer/back.grab_focus()

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameConfig.save_video_settings("fullscreen", toggled_on)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		GameConfig.save_video_settings("fullscreen", toggled_on)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
