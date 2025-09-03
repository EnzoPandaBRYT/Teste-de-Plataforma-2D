extends TileMapLayer

func disable_one_way():
	$".".one_way_collision = false
	await get_tree().create_timer(0.3).timeout # tempo pra atravessar
	$".".one_way_collision = true
