@tool
extends Area2D

@export var value : int = 50
@export var treasure_sprite : Texture2D:
	set(val):
		$Sprite2D.texture = val
		treasure_sprite = val

signal stolen

func steal() -> void:
	emit_signal("stolen", value)
	queue_free()
