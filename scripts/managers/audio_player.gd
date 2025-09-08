extends AudioStreamPlayer

#Music
#const menu_music = preload("res://sounds/music/Creatones - My Home (No Fades).mp3")
const menu_music = preload("res://sounds/cutscenes/Provisory-Main-Theme.mp3")
const level_1 = preload("res://sounds/music/A New Chance to Myself.mp3")

func _play_music(music: AudioStream, volume = -9.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

# Music
func play_music_menu():
	_play_music(menu_music)

func play_music_level1():
	_play_music(level_1)

func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX" 
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
