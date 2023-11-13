extends Node

const _Testbed : PackedScene = preload("res://scenes/testbed.tscn")

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var timer_restart_level : Timer = $Timer_RestartLevel

var level : Node

func _on_level_game_over() -> void:
	timer_restart_level.start()

func _on_timer_restart_level_timeout() -> void:
	anim_player.play("anim_out")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	if anim_name == "anim_out":
		level.queue_free()
		level = null
		spawn_level()
		anim_player.play("anim_in")

func spawn_level() -> void:
	level = _Testbed.instantiate()
	level.connect("game_over", _on_level_game_over)
	add_child(level)

func _ready() -> void:
	spawn_level()
	anim_player.play("anim_in")
