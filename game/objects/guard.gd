extends CharacterBody2D

const WALK_SPEED : float = 40.0
const THINKING_TIME : float = 0.5

enum State {WAITING_AT_POINT, PATROLLING, ENTERING_SLEEP, SLEEPING, LEAVING_SLEEP, SPOTTED_PLAYER, ALERT}

@export_node_path("Node2D") var path_patrol_points

@onready var sprite : Sprite2D = $Sprite2D
@onready var patrol_points : Node2D = get_node(path_patrol_points)
@onready var raycasts : Node2D = $Raycasts_Detection
@onready var sprite_question : Sprite2D = $Sprite_Question
@onready var sprite_exclamation : Sprite2D = $Sprite_Exclamation

var current_state : int = State.PATROLLING
var patrol_point_index : int = 0
var thinking_time : float = 0.0
var waiting_time : float = 2.0
var sleeping_time : float
var anim_index : float = 0.0

func select_next_patrol_point() -> void:
	patrol_point_index = wrapi(patrol_point_index + 1, 0, patrol_points.get_child_count())

func get_current_patrol_point() -> Node2D:
	return patrol_points.get_child(patrol_point_index)

func can_see_player() -> bool:
	var collider : Node2D = get_raycast_collider()
	if collider != null:
		if collider.is_in_group("player") and collider.can_be_spotted():
			return true
	return false

func get_player() -> Node2D:
	var collider : Node2D = get_raycast_collider()
	if collider != null:
		if collider.is_in_group("player") and collider.can_be_spotted():
			return collider
	return null

func get_raycast_collider() -> Node2D:
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return raycast.get_collider()
	return null

func _physics_process_waiting(delta : float) -> void:
	anim_index += delta * 10.0
	sprite.frame = wrapf(anim_index, 0, 9)
	if can_see_player():
		current_state = State.SPOTTED_PLAYER
		thinking_time = THINKING_TIME
		sprite_question.show()
		get_player().seen()
	else:
		waiting_time -= delta
		if waiting_time <= 0.0:
			select_next_patrol_point()
			current_state = State.PATROLLING

func _physics_process_patrolling(delta : float) -> void:
	anim_index += delta * 10.0
	sprite.frame = 10 + wrapf(anim_index, 0, 10)
	if can_see_player():
		current_state = State.SPOTTED_PLAYER
		thinking_time = THINKING_TIME
		sprite_question.show()
		get_player().seen()
	else:
		var destination_position : Vector2 = get_current_patrol_point().global_position
		var distance_to_destination : float = global_position.distance_to(destination_position)
		if distance_to_destination < 2.0:
			if get_current_patrol_point().sleep_time > 0.0:
				current_state = State.ENTERING_SLEEP
				sleeping_time = get_current_patrol_point().sleep_time
				anim_index = 0.0
			else:
				current_state = State.WAITING_AT_POINT
				waiting_time = get_current_patrol_point().wait_time
		else:
			if destination_position.x > global_position.x:
				sprite.flip_h = false
				raycasts.scale.x = 1.0
				move_and_collide(Vector2.RIGHT * WALK_SPEED * delta)
			else:
				sprite.flip_h = true
				raycasts.scale.x = -1.0
				move_and_collide(Vector2.LEFT * WALK_SPEED * delta)

func _physics_process_entering_sleep(delta : float) -> void:
	anim_index += delta * 10.0
	sprite.frame = 20 + clampf(anim_index, 0.0, 7.0)
	if anim_index >= 8.0:
		current_state = State.SLEEPING
		anim_index = 0.0

func _physics_process_sleeping(delta : float) -> void:
	anim_index += delta * 10.0
	sprite.frame = 30 + wrapf(anim_index, 0.0, 8.0)
	sleeping_time -= delta
	if sleeping_time <= 0.0:
		current_state = State.LEAVING_SLEEP
		anim_index = 0.0

func _physics_process_leaving_sleep(delta : float) -> void:
	anim_index += delta * 10.0
	sprite.frame = 38 + clampf(anim_index, 0.0, 1.0)
	if anim_index >= 2.0:
		current_state = State.WAITING_AT_POINT
		waiting_time = get_current_patrol_point().wait_time
		anim_index = 0.0

func _physics_process_spotted_player(delta : float) -> void:
	sprite.frame = 0
	thinking_time -= delta
	if thinking_time <= 0.0:
		if can_see_player():
			get_player().catch()
			current_state = State.ALERT
			sprite_question.hide()
			sprite_exclamation.show()
		else:
			current_state = State.PATROLLING
			sprite_question.hide()

func _physics_process(delta : float) -> void:
	match current_state:
		State.WAITING_AT_POINT: _physics_process_waiting(delta)
		State.PATROLLING: _physics_process_patrolling(delta)
		State.ENTERING_SLEEP: _physics_process_entering_sleep(delta)
		State.SLEEPING: _physics_process_sleeping(delta)
		State.LEAVING_SLEEP: _physics_process_leaving_sleep(delta)
		State.SPOTTED_PLAYER: _physics_process_spotted_player(delta)
