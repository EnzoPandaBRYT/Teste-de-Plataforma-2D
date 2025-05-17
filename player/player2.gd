extends Character

func _idle() -> void:
	_enter_state("idle")

func _walk() -> void:
	_enter_state("walking")
