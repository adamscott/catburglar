extends Control

@onready var label_level_name : Label = $Label_LevelName
@onready var label_level_description : Label = $VBox/Label_Description
@onready var label_level_objectives : Label = $VBox/Label_Objectives
@onready var audio_vo : AudioStreamPlayer = $Audio_VO

func _ready() -> void:
	label_level_name.text = Constants.get_level_name(GameProgress.current_level)
	label_level_description.text = Constants.get_level_briefing(GameProgress.current_level)
	label_level_objectives.text = Constants.get_level_objectives(GameProgress.current_level)
	audio_vo.stream = load(Constants.get_level_vo_path(GameProgress.current_level))
	audio_vo.play()
