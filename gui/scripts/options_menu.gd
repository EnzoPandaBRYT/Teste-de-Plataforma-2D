extends Node

var fullscreen_toggle = false

#Sliders
@onready var masterSlider = $MasterVolume/HBoxContainer/masterSlider
@onready var sfxSlider = $SFXVolume/HBoxContainer/sfxSlider

#Botões
@onready var fullscreenButton = $Resolution/HBoxContainer/CheckBox
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
		fullscreenButton.button_pressed = true
	else:
		fullscreenButton.button_pressed = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen_toggle") and !fullscreen_toggle:
		fullscreenButton.button_pressed = true
		fullscreen_toggle = true
	elif Input.is_action_just_pressed("fullscreen_toggle") and fullscreen_toggle:
		fullscreenButton.button_pressed = false
		fullscreen_toggle = false

func _on_back_pressed() -> void:
	$"../section".play_backwards("change_options")
	if GeneralVars._ControllersConnected > 0:
		$"../MainMenu/Panel2/container/options".grab_focus()

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


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameConfig.save_video_settings("fullscreen", toggled_on)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		GameConfig.save_video_settings("fullscreen", toggled_on)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
