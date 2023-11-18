extends Area2D

@export var dialogue_slug : String

var triggered : bool = false

signal activated

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player") and not triggered:
		emit_signal("activated", dialogue_slug)
		triggered = true
