extends Node

var masterVolumeValue = 100
var sfxVolumeValue = 100
var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://setting.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "move_left", "Seta Esquerda")
		config.set_value("keybinding", "move_right", "Seta Direita")
		config.set_value("keybinding", "jump", "Seta para Cima ou Espaço")
		config.set_value("keybinding", "crouch", "Seta para Baixo")
		config.set_value("keybinding", "run", "Shift Esquerdo")
		
		config.set_value("video", "fullscreen", true)
		
		config.set_value("audio", "masterVolume", 1.0) # É multiplicado por 100 depois! (options_menu)
		config.set_value("audio", "sfxVolume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		# Master Volume
		masterVolumeValue = config.get_value("audio", "masterVolume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterVolumeValue))
		
		# SFX Volume
		sfxVolumeValue = config.get_value("audio", "sfxVolume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfxVolumeValue))
		print(masterVolumeValue)
		print(sfxVolumeValue)

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	
func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
