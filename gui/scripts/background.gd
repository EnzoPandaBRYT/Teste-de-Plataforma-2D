extends Sprite2D

@onready var my_sprite = $"."

func _ready() -> void:
	my_sprite.self_modulate = Color(1, 0, 1) # Sets the sprite to red (RGB values from 0 to 1)
	
