extends Camera2D

const MOVE_SPEED : float = 2.0

@export_node_path("Node2D") var player

func _process(delta : float) -> void:
	var p : Node2D = get_node(player)
	var pos : Vector2 = p.global_position
	global_position = lerp(global_position, pos, MOVE_SPEED * delta)
