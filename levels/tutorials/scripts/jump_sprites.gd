extends CanvasLayer

@onready var jump_arrow = $arrow
@onready var jump_a_button = $"a-button"

func _process(delta: float) -> void:
	if GeneralVars.usingController:
		jump_a_button.visible = true
		jump_arrow.visible = false
	else:
		jump_a_button.visible = false
		jump_arrow.visible = true
