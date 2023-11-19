extends Area2D

const ANIM_SPEED : float = 24.0

@export_node_path("Node2D") var destination

@onready var sprite : Sprite2D = $Sprite2D
@onready var timer_close_door : Timer = $Timer_CloseDoor

var actual_frame : float = 0.0
var target_frame : float = 0.0

func _on_timer_close_door_timeout() -> void:
	target_frame = 0.0

func get_destination() -> Node2D:
	return get_node(destination)

func open() -> void:
	target_frame = 6.0
	timer_close_door.start()

func _physics_process(delta : float) -> void:
	actual_frame = move_toward(actual_frame, target_frame, ANIM_SPEED * delta)
	sprite.frame = actual_frame
