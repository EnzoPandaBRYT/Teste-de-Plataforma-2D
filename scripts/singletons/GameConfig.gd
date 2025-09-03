extends Node

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
		
		config.set_value("audio", "volume_db", 100)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
