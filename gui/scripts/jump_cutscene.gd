extends Label

@onready var anim = $"../Cutscene Anim"

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if GeneralVars.can_jump_cutscene == true:
		visible = true
		anim.play("fade_jump_cutscene")
	else:
		anim.play("fade_out_jump_cutscene")


func _on_camera_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zone_1":
		GeneralVars.can_jump_cutscene = false
		await get_tree().create_timer(0.5).timeout
		visible = false
