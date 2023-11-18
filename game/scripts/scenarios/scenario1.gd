extends Node

const LOOT_REQUIRED : int = 100

@export_node_path("Node") var path_level_controller
@onready var level_controller : Node = get_node(path_level_controller)

@export_node_path("CanvasLayer") var path_hud
@onready var hud : CanvasLayer = get_node(path_hud)

@export_node_path("Node2D") var path_level_exit
@onready var level_exit : Node2D = get_node(path_level_exit)

var objective_complete : bool = false

func _on_loot_value_changed(loot : int) -> void:
	if loot >= 200 and !objective_complete:
		hud.update_objective_value("Escape.")
		hud.show_objective()
		objective_complete = true
		level_exit.become_active()
		level_controller.play_dialogue("level1_goal")

func _ready() -> void:
	hud.update_objective_value("Steal at least $500 worth of loot.")
	hud.show_objective()
