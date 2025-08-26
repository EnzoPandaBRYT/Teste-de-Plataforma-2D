extends Label

var t := 0.0

func _process(delta):
	t += delta
	# movimento suave
	var x = sin(t * 2.0) * 5      # vai e volta pros lados
	var y = cos(t * 2.0) * 10     # sobe e desce
	var rot = sin(t * 2.0) * 5    # gira de -5° a +5°

	position = Vector2(161, 10) + Vector2(x, y) # muda (200,200) pra posição base do label
	rotation_degrees = rot
