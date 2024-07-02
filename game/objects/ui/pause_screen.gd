extends Control

enum State {INACTIVE, ANIM_IN, ACTIVE, ANIM_OUT}

var current_state : int = State.INACTIVE

@onready var anim_player : AnimationPlayer = $AnimationPlayer

signal exited

func appear() -> void:
	anim_player.play("appear")
	current_state = State.ANIM_IN

func disappear() -> void:
	anim_player.play("disappear")
	current_state = State.ANIM_OUT

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"appear":
			current_state = State.ACTIVE
		"disappear":
			current_state = State.INACTIVE
			emit_signal("exited")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause") and current_state == State.ACTIVE:
		disappear()
