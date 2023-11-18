extends Control

enum State {INTRO, MENU, SETTINGS, CREDITS, FADE_OUT_GAME, FADE_OUT_QUIT}

@onready var main_menu : Control = $MainMenu
@onready var menu : Control = $MainMenu/Menu
@onready var credits : Control = $Credits
@onready var video_player : VideoStreamPlayer = $VideoStreamPlayer
@onready var audio_bgm : AudioStreamPlayer = $Audio_BGM
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var current_state : int = State.INTRO

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		match current_state:
			State.CREDITS:
				credits.hide()
				main_menu.show()
				current_state = State.MENU
	elif event.is_action_pressed("interact"):
		match current_state:
			State.INTRO:
				anim_player.seek(10.0, true)
				current_state = State.MENU
				menu.active = true

func _on_menu_item_selected(item_name : String) -> void:
	match item_name:
		"Play":
			current_state = State.FADE_OUT_GAME
			anim_player.play("fade_out")
		"Credits":
			main_menu.hide()
			credits.show()
			current_state = State.CREDITS
		"Quit":
			current_state = State.FADE_OUT_QUIT
			anim_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"fade_in":
			current_state = State.MENU
			menu.active = true
		"fade_out":
			match current_state:
				State.FADE_OUT_GAME: get_tree().change_scene_to_file("res://scenes/game.tscn")
				State.FADE_OUT_QUIT: get_tree().quit()

func _on_video_stream_player_finished() -> void:
	video_player.play()

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	audio_bgm.play()
	anim_player.play("fade_in")

