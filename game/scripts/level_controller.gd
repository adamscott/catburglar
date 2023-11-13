extends Node

@export_node_path("Node") var path_scenario
@onready var scenario : Node = get_node(path_scenario)

@onready var hud : CanvasLayer = $HUD

var loot : int = 0

func _on_player_caught() -> void:
	hud.do_game_over()

func _on_treasure_stolen(value : int) -> void:
	loot += value
	hud.update_loot_value(loot)
	hud.show_loot()
	scenario._on_loot_value_changed(loot)
