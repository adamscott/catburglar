extends Camera2D

const MOVE_SPEED : float = 4.0

@export_node_path("Node2D") var player

func zoom_in() -> void:
	create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(self, "zoom", Vector2(6, 6), 1.0)

func zoom_out() -> void:
	create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(self, "zoom", Vector2(3, 3), 2.0)

func _process(delta : float) -> void:
	var p : Node2D = get_node(player)
	var pos : Vector2 = p.global_position
	global_position = lerp(global_position, pos, MOVE_SPEED * delta)
