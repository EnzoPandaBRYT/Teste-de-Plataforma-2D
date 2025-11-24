extends Area2D

@onready var anim = $"../camera_anim"

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		anim.speed_scale = 3
	if Input.is_action_just_released("jump"):
		anim.speed_scale = 1

func _on_body_entered(body: Node2D) -> void:
	GeneralVars.in_cutscene = true
	GeneralVars.can_jump_cutscene = true
	anim.play("zone_1")

func _on_camera_anim_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(0.1).timeout
	GeneralVars.in_cutscene = false
	queue_free()
