extends Area2D

# Referência à Camera2D
@onready var camera_main = $"../player/Camera2D"
@onready var camera_sec = $"../Camera_Area"

# Quando o jogador entra na área
func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "player":  # Verifique se o corpo é o jogador
		camera_sec.make_current()
		

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		camera_main.make_current()
