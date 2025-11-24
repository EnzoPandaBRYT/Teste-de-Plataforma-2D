extends Area2D

@onready var jump_anim = $"../../../Animations/jump_tutorial"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and GeneralVars.currentTutorial != "JumpTutorial" and GameConfig.allowTutorials:
		GeneralVars.currentTutorial = "JumpTutorial"
		jump_anim.play("fade_in")
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and GeneralVars.currentTutorial == "JumpTutorial" and GameConfig.allowTutorials:
		jump_anim.play("fade_out")
		queue_free()
