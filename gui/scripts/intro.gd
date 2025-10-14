extends Control

const intro = preload("res://sounds/cutscenes/Intro Sound.mp3")
@onready var animation = $animation

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation.play("RESET")
	await get_tree().create_timer(0.25).timeout
	animation.play("intro")
	AudioPlayer.play_FX(intro, 0.0)
	
	if GameConfig.config.get_value("video", "fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		animation.play("intro_text")
		await get_tree().create_timer(1.5).timeout
		animation.play("fade_out")
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")
