extends Node

@export_node_path("Node") var path_scenario
@onready var scenario : Node = get_node(path_scenario)

@export_node_path("Node2D") var path_player
@onready var player : Node2D = get_node(path_player)

@onready var hud : CanvasLayer = $HUD

var loot : int = 0

signal game_over

func _on_player_caught() -> void:
	hud.do_game_over()
	emit_signal("game_over")

func _on_treasure_stolen(value : int) -> void:
	loot += value
	hud.update_loot_value(loot)
	hud.show_loot()
	scenario._on_loot_value_changed(loot)

func _on_hud_minigame_succeeded() -> void:
	player.stop_hacking()

func _on_hud_minigame_failed() -> void:
	player.stop_hacking()

func _on_player_started_hacking() -> void:
	hud.start_minigame()
