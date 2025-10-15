extends Area2D

@onready var anim = $"../camera_anim"

func _on_body_entered(body: Node2D) -> void:
	GeneralVars.in_cutscene = true
	anim.play("zone_1")

func _on_camera_anim_animation_finished(anim_name: StringName) -> void:
	GeneralVars.in_cutscene = false
	queue_free()
