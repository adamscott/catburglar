extends Node

const LOOT_REQUIRED : int = 100

@export_node_path("Node") var path_level_controller
@onready var level_controller : Node = get_node(path_level_controller)

@export_node_path("CanvasLayer") var path_hud
@onready var hud : CanvasLayer = get_node(path_hud)

@export_node_path("Node2D") var path_level_exit
@onready var level_exit : Node2D = get_node(path_level_exit)

var objective_complete : bool = false
var secondary_objective_complete : bool = false

func _on_loot_value_changed(loot : int) -> void:
	pass

func _on_vase_stolen(value : int) -> void:
	hud.update_objective_value("Escape.")
	hud.show_objective()
	objective_complete = true
	level_exit.become_active()
	level_controller.play_dialogue("level2_goal")

func _on_hud_minigame_succeeded() -> void:
	GameProgress.secondary_objective_met = true
	level_controller.play_dialogue("level2_computer")

func _ready() -> void:
	hud.update_objective_value("Steal the vase.")
	hud.show_objective()
