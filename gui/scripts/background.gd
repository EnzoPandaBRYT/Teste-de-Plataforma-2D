extends Sprite2D

@onready var my_sprite = $"."

func _ready() -> void:
	my_sprite.flip_h = true
