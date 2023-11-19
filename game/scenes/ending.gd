extends Control

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(anim_name : String) -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	anim_player.play("ending")
