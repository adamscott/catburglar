extends Area2D

@export_node_path("Light2D") var path_light
@onready var light : Light2D = get_node(path_light)

func interact() -> void:
	light.enabled = !light.enabled
