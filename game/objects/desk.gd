extends Area2D

func is_hiding_player() -> bool:
	var bodies : Array[Node2D] = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			return true
	return false
