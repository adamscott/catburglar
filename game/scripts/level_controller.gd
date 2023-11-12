extends Node

@onready var hud : CanvasLayer = $HUD

var loot : int = 0

func _on_player_caught() -> void:
	pass

func _on_treasure_stolen(value : int) -> void:
	loot += value
	hud.update_loot_value(loot)
