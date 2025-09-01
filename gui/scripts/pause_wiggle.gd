extends Label

var t := 1.0

func _process(delta):
	t += delta
	# movimento suave
	var x = sin(t * 1.5) * 5      # vai e volta pros lados
	var y = cos(t * 2.0) * 10     # sobe e desce
	var rot = sin(t * 2.0) * 10    # gira de -5° a +5°

	position = Vector2(206.5, 10) + Vector2(x, y) # muda (200,200) pra posição base do label
	rotation_degrees = rot
