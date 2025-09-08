extends Control

const intro = preload("res://sounds/cutscenes/Intro Sound.mp3")
@onready var animation = $animation

func _ready() -> void:
	animation.play("RESET")
	await get_tree().create_timer(0.25).timeout
	animation.play("intro")
	AudioPlayer.play_FX(intro, 0.0)
	


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		animation.play("intro_text")
		await get_tree().create_timer(1.5).timeout
		animation.play("fade_out")
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://gui/scenes/main_menu.tscn")
