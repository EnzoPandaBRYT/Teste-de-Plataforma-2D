extends Area2D

# Referência à Camera2D
@onready var camera = $"../player/Camera2D"

# Quando o jogador entra na área
func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "player":  # Verifique se o corpo é o jogador
		camera.position.x = 508
		camera.position.y = -121

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		camera.process_mode = Camera2D.PROCESS_MODE_INHERIT
