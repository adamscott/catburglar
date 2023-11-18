extends Control

@onready var label_time_taken_value : Label = $GridContainer/Label_TimeTaken_Value
@onready var label_loot_value : Label = $GridContainer/Label_Loot_Value
@onready var label_alerts_value : Label = $GridContainer/Label_Alerts_Value
@onready var label_rank_value : Label = $GridContainer/Label_Rank_Value

func _ready() -> void:
	label_time_taken_value.text = Utilities.int_to_timestamp(GameProgress.time_taken)
	label_loot_value.text = "$" + str(GameProgress.loot)
	label_alerts_value.text = str(GameProgress.camera_alerts)
