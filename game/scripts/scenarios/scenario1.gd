extends Node

const LOOT_REQUIRED : int = 100

@export_node_path("CanvasLayer") var path_hud
@onready var hud = get_node(path_hud)

var objective_complete : bool = false

func _on_loot_value_changed(loot : int) -> void:
	if loot >= 100 and !objective_complete:
		hud.update_objective_value("Escape.")
		hud.show_objective()
		objective_complete = true

func _ready() -> void:
	hud.update_objective_value("Steal at least $100 worth of loot.")
	hud.show_objective()
