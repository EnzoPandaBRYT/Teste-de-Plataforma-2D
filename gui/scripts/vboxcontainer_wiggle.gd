extends VBoxContainer

@export var amplitude: float = 5.0
@export var rotation_strength: float = 1.5
@export var speed: float = 1.1
@export var offset: Vector2 = Vector2(0, 0) # empurra o grupo mais pra baixo ou pro lado

var time: float = 0.0
var base_position: Vector2

func _ready() -> void:
	# guarda a posição inicial (já com o offset aplicado)
	base_position = position + offset
	position = base_position

func _process(delta: float) -> void:
	time += delta * speed

	# offsets em relação à posição base
	var x = cos(time * 0.5) * amplitude * 0.5
	var y = sin(time) * amplitude

	position = base_position + Vector2(x, y)
	rotation = deg_to_rad(sin(time * 1.5) * rotation_strength)
