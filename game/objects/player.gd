extends CharacterBody2D

const WALK_SPEED : float = 80.0
const IN_AIR_MOVE_SPEED : float = 40.0
const HALF_ROLL_SPEED : float = 120.0
const ROLL_SPEED : float = 160.0
const MAX_ROLL_DISTANCE : float = 96.0
const MAX_FALL_SPEED : float = 192.0
const FALL_INCR : float = 512.0
const LAND_THRESHOLD : float = 128.0
const PLATFORMS_OFF_LENGTH : float = 0.1

@onready var sprite : Sprite2D = $Sprite2D
@onready var area_interact : Area2D = $Area2D_Interact

enum State {NORMAL, CROUCHING_DOWN, CROUCHED, STANDING_UP, ENTERING_ROLL, ROLLING, LEAVING_ROLL, FALLING, LANDING, ENTERING_BOX, IN_BOX, LEAVING_BOX, ENTERING_DOOR, LEAVING_DOOR, SWIPING, PICKING_LOCK, CRACKING_SAFE, CAUGHT}

var current_state : int = State.NORMAL
var anim_index : float = 0.0
var door_destination : Vector2

var facing : Vector2 = Vector2.RIGHT
var roll_distance : float
var fall_velocity : float = 0.0
var platforms_on_timer : float = 0.0

var lit : bool = false
var obscured : bool = false

signal caught

func can_interact() -> bool:
	return area_interact.has_overlapping_areas()

# This function assumes that we'll never be overlapping two or more interactables at once
func get_interact_action_label() -> String:
	var interactables : Array[Area2D] = area_interact.get_overlapping_areas()
	for interactable in interactables:
		if interactable.is_in_group(&"stealable"):
			return &"Steal"
		elif interactable.is_in_group(&"hiding_place"):
			return &"Hide"
		elif interactable.is_in_group(&"door"):
			return &"Enter"
		elif interactable.is_in_group(&"level_exit"):
			return &"Escape"
		elif interactable.is_in_group(&"readable"):
			return &"Read"
	return &""

func can_be_spotted() -> bool:
	return current_state in [State.NORMAL, State.CROUCHING_DOWN, State.CROUCHED, State.STANDING_UP, State.ENTERING_ROLL, State.ROLLING, State.LEAVING_ROLL, State.PICKING_LOCK, State.CRACKING_SAFE] and lit and !obscured

func update_obscured() -> void:
	obscured = false
	for node in get_tree().get_nodes_in_group(&"obscurer"):
		if node.is_hiding_player():
			obscured = true

func spotted() -> void:
	current_state = State.CAUGHT
	anim_index = 0.0
	emit_signal(&"caught")

func try_to_interact() -> void:
	var interactables : Array[Area2D] = area_interact.get_overlapping_areas()
	if interactables.size() > 0:
		var interactable : Area2D = interactables[0]
		if interactable.is_in_group(&"door"):
			door_destination = interactable.get_destination_position()
			current_state = State.ENTERING_DOOR
			anim_index = 0.0
		else:
			interactable.interact()
			current_state = State.SWIPING
			anim_index = 0.0

func on_ground() -> bool:
	var collision : KinematicCollision2D = move_and_collide(Vector2.DOWN * 0.25, true)
	return collision != null

func do_horizontal_movement(movement_desired : float, speed : float, delta : float) -> void:
	sprite.flip_h = movement_desired < 0.0
	facing = Vector2.RIGHT if movement_desired > 0.0 else Vector2.LEFT
	var collision : KinematicCollision2D = move_and_collide(Vector2.RIGHT * movement_desired * delta * WALK_SPEED)
	if collision != null:
		var normal : Vector2 = collision.get_normal().snapped(Vector2(0.25, 0.25))
		if normal == Vector2(0.75, -0.75):
			move_and_collide(Vector2(-1, -1) * collision.get_remainder().length())
		elif normal == Vector2(-0.75, -0.75):
			move_and_collide(Vector2(1, -1) * collision.get_remainder().length())

func do_rolling_horizontal_movement(speed : float, delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(facing * speed * delta)
	if collision != null:
		var normal : Vector2 = collision.get_normal().snapped(Vector2(0.25, 0.25))
		if normal == Vector2(0.75, -0.75):
			move_and_collide(Vector2(-1, -1) * collision.get_remainder().length())
		elif normal == Vector2(-0.75, -0.75):
			move_and_collide(Vector2(1, -1) * collision.get_remainder().length())
		elif normal in [Vector2.LEFT, Vector2.RIGHT]:
			facing.x *= -1.0
			sprite.flip_h = !sprite.flip_h

func do_rolling_fall(delta : float) -> void:
	if not on_ground():
		velocity.y = clampf(velocity.y + (FALL_INCR * delta), -MAX_FALL_SPEED, MAX_FALL_SPEED)
		var fall_collision : KinematicCollision2D = move_and_collide(velocity * delta)
		if fall_collision != null:
			if velocity.y > LAND_THRESHOLD:
				current_state = State.LEAVING_ROLL
			anim_index = 0.0
			velocity.y = 0.0

func _physics_process_entering_door(delta : float) -> void:
	obscured = false
	anim_index += delta * 4.0
	sprite.modulate.a = 1.0 - anim_index
	if anim_index >= 1.0: # TODO: tweak this
		current_state = State.LEAVING_DOOR
		global_position = door_destination
		anim_index = 0.0

func _physics_process_leaving_door(delta : float) -> void:
	obscured = false
	anim_index += delta * 4.0
	sprite.modulate.a = anim_index
	if anim_index >= 1.0: # TODO: tweak this
		current_state = State.NORMAL
		anim_index = 0.0
		sprite.modulate.a = 1.0

func _physics_process_crouching_down(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 28 + clampf(anim_index, 0.0, 4.0)
	if anim_index >= 4.0:
		current_state = State.CROUCHED
		anim_index = 0.0
	if Input.is_action_just_pressed(&"interact"):
		set_collision_mask_value(4, false)
		platforms_on_timer = PLATFORMS_OFF_LENGTH
	if not on_ground():
		current_state = State.FALLING
		anim_index = 0.0
	else:
		set_collision_mask_value(4, true)
		if not Input.is_action_pressed(&"down"):
			current_state = State.STANDING_UP
			anim_index = 0.0
		elif Input.is_action_pressed(&"right"):
			sprite.flip_h = false
			facing = Vector2.RIGHT
			roll_distance = MAX_ROLL_DISTANCE
			current_state = State.ENTERING_ROLL
			anim_index = 0.0
		elif Input.is_action_pressed(&"left"):
			sprite.flip_h = true
			facing = Vector2.LEFT
			roll_distance = MAX_ROLL_DISTANCE
			current_state = State.ENTERING_ROLL
			anim_index = 0.0

func _physics_process_crouched(delta : float) -> void:
	update_obscured()
	sprite.frame = 33
	if Input.is_action_just_pressed(&"interact"):
		set_collision_mask_value(4, false)
		platforms_on_timer = PLATFORMS_OFF_LENGTH
	if not on_ground():
		current_state = State.FALLING
		anim_index = 0.0
	else:
		set_collision_mask_value(4, true)
		if not Input.is_action_pressed(&"down"):
			current_state = State.STANDING_UP
			anim_index = 0.0
		elif Input.is_action_pressed(&"right"):
			sprite.flip_h = false
			facing = Vector2.RIGHT
			roll_distance = MAX_ROLL_DISTANCE
			current_state = State.ENTERING_ROLL
			anim_index = 0.0
		elif Input.is_action_pressed(&"left"):
			sprite.flip_h = true
			facing = Vector2.LEFT
			roll_distance = MAX_ROLL_DISTANCE
			current_state = State.ENTERING_ROLL
			anim_index = 0.0

func _physics_process_standing_up(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 34 + clampf(anim_index, 0.0, 1.0)
	if anim_index >= 2.0:
		current_state = State.NORMAL

func _physics_process_entering_roll(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 84 + clampf(anim_index, 0.0, 1.0)
	if anim_index >= 2.0:
		current_state = State.ROLLING
		anim_index = 0.0
	do_rolling_horizontal_movement(HALF_ROLL_SPEED, delta)
	do_rolling_fall(delta)

func _physics_process_rolling(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 86 + wrapf(anim_index, 0.0, 4.0)
	do_rolling_horizontal_movement(ROLL_SPEED, delta)
	do_rolling_fall(delta)
	roll_distance -= ROLL_SPEED * delta
	if (roll_distance <= 0.0 or Input.is_action_just_pressed(&"interact")) and on_ground():
		current_state = State.LEAVING_ROLL
		anim_index = 0.0

func _physics_process_leaving_roll(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 90 + clampf(anim_index, 0.0, 1.0)
	if anim_index >= 2.0:
		current_state = State.CROUCHED
		anim_index = 0.0
	do_rolling_horizontal_movement(HALF_ROLL_SPEED, delta)
	do_rolling_fall(delta)

func _physics_process_normal(delta : float) -> void:
	obscured = false
	var movement_desired : float = Input.get_axis(&"left", &"right")
	if movement_desired != 0.0:
		do_horizontal_movement(movement_desired, WALK_SPEED, delta)
	if not on_ground():
		current_state = State.FALLING
		anim_index = 0.0
	elif Input.is_action_just_pressed(&"interact"):
		try_to_interact()
	elif Input.is_action_just_pressed(&"down"):
		current_state = State.CROUCHING_DOWN
		anim_index = 0.0
	anim_index += delta * 10.0
	if movement_desired == 0.0:
		sprite.frame = wrapf(anim_index, 0, 14)
	else:
		sprite.frame = 14 + wrapf(anim_index, 0, 8)

func _physics_process_falling(delta : float) -> void:
	obscured = false
	anim_index += delta * 15.0
	sprite.frame = 98 + clampf(anim_index, 0.0, 1.0)
	if platforms_on_timer > 0.0:
		platforms_on_timer -= delta
	else:
		set_collision_mask_value(4, true)
	var movement_desired : float = Input.get_axis(&"left", &"right")
	if movement_desired != 0.0:
		do_horizontal_movement(movement_desired, IN_AIR_MOVE_SPEED, delta)
	velocity.y = clampf(velocity.y + (FALL_INCR * delta), -MAX_FALL_SPEED, MAX_FALL_SPEED)
	var fall_collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if fall_collision != null:
		set_collision_mask_value(4, true)
		if velocity.y > LAND_THRESHOLD:
			current_state = State.CROUCHED if Input.is_action_pressed(&"down") else State.LANDING
			anim_index = 0.0
			velocity.y = 0.0
		else:
			current_state = State.NORMAL

func _physics_process_landing(delta : float) -> void:
	update_obscured()
	anim_index += delta * 15.0
	sprite.frame = 100 + clampf(anim_index, 0.0, 3.0)
	if anim_index >= 4.0:
		current_state = State.NORMAL

func _physics_process_swiping(delta : float) -> void:
	obscured = false
	anim_index += delta * 15.0
	sprite.frame = 56 + clampf(anim_index, 0.0, 8.0)
	if anim_index >= 9.0:
		current_state = State.NORMAL

func _physics_process_caught(delta : float) -> void:
	obscured = false
	anim_index += delta * 15.0
	sprite.frame = 70 + clampf(anim_index, 0.0, 4.0)

func _physics_process(delta : float) -> void:
	match current_state:
		State.CROUCHING_DOWN: _physics_process_crouching_down(delta)
		State.CROUCHED: _physics_process_crouched(delta)
		State.STANDING_UP: _physics_process_standing_up(delta)
		State.NORMAL: _physics_process_normal(delta)
		State.ENTERING_ROLL: _physics_process_entering_roll(delta)
		State.ROLLING: _physics_process_rolling(delta)
		State.LEAVING_ROLL: _physics_process_leaving_roll(delta)
		State.FALLING: _physics_process_falling(delta)
		State.LANDING: _physics_process_landing(delta)
		State.ENTERING_DOOR: _physics_process_entering_door(delta)
		State.LEAVING_DOOR: _physics_process_leaving_door(delta)
		State.SWIPING: _physics_process_swiping(delta)
		State.CAUGHT: _physics_process_caught(delta)
	lit = false
	for illuminator in get_tree().get_nodes_in_group(&"illuminator"):
		if illuminator.is_lighting_player():
			lit = true
