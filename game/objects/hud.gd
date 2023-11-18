extends CanvasLayer

const LOOT_SHOW_TIME : float = 3.0
const OBJECTIVE_SHOW_TIME : float = 6.0
const MOVE_SPEED : float = 4.0

@export_node_path("Node2D") var path_player
@onready var player : Node2D = get_node(path_player)

@onready var texture_in_light : TextureRect = $Texture_InLight
@onready var texture_in_shadow : TextureRect = $Texture_InShadow
@onready var texture_hidden : TextureRect = $Texture_Hidden
@onready var label_loot_value : Label = $Loot/Label_Loot_Value
@onready var label_objective_value : Label = $Objective/Label_Objective_Value
@onready var loot : Control = $Loot
@onready var objective : Control = $Objective
@onready var minigame : Node2D = $Minigame
@onready var greyout : ColorRect = $Greyout
@onready var dialogue : Control = $Dialogue
@onready var dialogue_line : Label = $Dialogue/Label_Line
@onready var audio_vo : AudioStreamPlayer = $Audio_VO

var loot_show_time : float = 0.0
var objective_show_time : float = 0.0

var game_over : bool = false
var grey_amount : float = 0.0

var playing_dialogue : bool = false

signal minigame_succeeded
signal minigame_failed
signal dialogue_finished

func _on_minigame_succeeded() -> void:
	minigame.hide()
	emit_signal("minigame_succeeded")

func _on_minigame_failed() -> void:
	minigame.hide()
	emit_signal("minigame_failed")

func _on_audio_vo_finished() -> void:
	create_tween().tween_property(dialogue, "modulate", Color.TRANSPARENT, 0.25)
	emit_signal("dialogue_finished")
	playing_dialogue = false

func start_minigame() -> void:
	minigame.start()
	minigame.show()

func start_dialogue(which : String) -> void:
	dialogue_line.text = Dialogues.get_dialogue_line(which)
	create_tween().tween_property(dialogue, "modulate", Color.WHITE, 0.25)
	audio_vo.stream = load(Dialogues.get_dialogue_vo_path(which))
	audio_vo.play()
	playing_dialogue = true

func do_game_over() -> void:
	game_over = true
	objective.hide()
	loot.hide()

func update_loot_value(loot : int) -> void:
	label_loot_value.text = "$" + str(loot)

func update_objective_value(objective : String) -> void:
	label_objective_value.text = objective

func show_loot() -> void:
	loot_show_time = LOOT_SHOW_TIME

func show_objective() -> void:
	objective_show_time = OBJECTIVE_SHOW_TIME

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("interact") and playing_dialogue:
		audio_vo.stop()
		_on_audio_vo_finished()

func _physics_process(delta : float) -> void:
	texture_in_light.visible = player.lit and !player.obscured and !game_over
	texture_in_shadow.visible = !player.lit and !game_over
	texture_hidden.visible = player.lit and player.obscured and !game_over
	var loot_target_pos : float = 16.0 if loot_show_time > 0.0 else -32.0
	var objective_target_pos : float = 680.0 if objective_show_time > 0.0 else 720.0
	if loot_show_time > 0.0: loot_show_time -= delta
	if objective_show_time > 0.0: objective_show_time -= delta
	loot.position.y = lerp(loot.position.y, loot_target_pos, MOVE_SPEED * delta)
	objective.position.y = lerp(objective.position.y, objective_target_pos, MOVE_SPEED * delta)
	if game_over:
		grey_amount = clampf(grey_amount + delta, 0.0, 1.0)
		greyout.material.set_shader_parameter("amount", grey_amount)

func _ready() -> void:
	greyout.material.set_shader_parameter("amount", grey_amount)
