extends Node

const _Testbed : PackedScene = preload("res://scenes/levels/level1.tscn")

@onready var audio_bgm : AudioStreamPlayer = $Audio_BGM
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var timer_restart_level : Timer = $Timer_RestartLevel

enum State {IN_GAME, PAUSED, GAME_OVER, LEVEL_COMPLETE}

var level : Node
var current_state : int = State.IN_GAME

func _on_level_complete() -> void:
	Utilities.pause_timer()
	GameProgress.time_taken = Utilities.get_time_taken_msec()
	current_state = State.LEVEL_COMPLETE
	anim_player.play("anim_out")

func _on_level_game_over() -> void:
	timer_restart_level.start()

func _on_timer_restart_level_timeout() -> void:
	current_state = State.GAME_OVER
	anim_player.play("anim_out")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"anim_out":
			if current_state == State.GAME_OVER:
				level.queue_free()
				level = null
				spawn_level()
				anim_player.play("anim_in")
			elif current_state == State.LEVEL_COMPLETE:
				get_tree().paused = false
				get_tree().change_scene_to_file("res://scenes/level_complete.tscn")

func spawn_level() -> void:
	level = _Testbed.instantiate()
	level.connect("complete", _on_level_complete)
	level.connect("game_over", _on_level_game_over)
	add_child(level)
	current_state = State.IN_GAME
	GameProgress.start_level()
	Utilities.start_timer()

func _ready() -> void:
	spawn_level()
	anim_player.play("anim_in")
	audio_bgm.stream = load(Constants.get_level_music_path(GameProgress.current_level))
	audio_bgm.play()
