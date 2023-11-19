extends Area2D

@export_node_path("Node2D") var destination

func get_destination() -> Node2D:
	return get_node(destination)

func open() -> void:
	pass
