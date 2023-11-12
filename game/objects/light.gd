extends PointLight2D

@export var light_range : float

@onready var raycast : RayCast2D = $RayCast2D

func is_lighting_player() -> bool:
	return raycast.is_colliding() and raycast.get_collider().is_in_group("player")

func _physics_process(delta : float) -> void:
	var players : Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player : Node2D = players[0]
		raycast.target_position = player.global_position - self.global_position
		raycast.target_position = raycast.target_position.limit_length(light_range)
