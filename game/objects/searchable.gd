extends Area2D

@export var value : float
@export var description : String

var searched : bool = false

signal looted

func search() -> void:
	searched = true
	emit_signal("looted", value, description)
