extends Area2D

@export_node_path("Node2D") var destination

func get_destination_position() -> Vector2:
	var dest : Node2D = get_node(destination)
	return dest.global_position
