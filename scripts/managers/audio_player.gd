extends AudioStreamPlayer

#Music
#const menu_music = preload("res://sounds/music/Creatones - My Home (No Fades).mp3")
const menu_music = preload("res://sounds/cutscenes/Provisory-Main-Theme.mp3")
const intro_lvl_1 = preload("res://sounds/music/I'm In Madness - Intro.mp3")
const level_1 = preload("res://sounds/music/I'm In Madness - Loop.mp3")

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
	_play_music(intro_lvl_1)
	await self.finished
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

func fade_to_music(fade_time := 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fade_time) # fade out
	
	
func music_reduce(new_volume := -18.0, fade_time := 0.5, pitch = 0.75):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", new_volume, fade_time) # fade out
	tween.tween_property(AudioPlayer, "pitch_scale", pitch, fade_time)

func music_normal(old_volume := -9.0, fade_time := 0.5, pitch = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", old_volume, fade_time) # fade out
	tween.tween_property(self, "pitch_scale", pitch, fade_time)
