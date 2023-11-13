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
@onready var greyout : ColorRect = $Greyout

var loot_show_time : float = 0.0
var objective_show_time : float = 0.0

var game_over : bool = false
var grey_amount : float = 0.0

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

func _physics_process(delta : float) -> void:
	texture_in_light.visible = player.lit and !player.obscured and !game_over
	texture_in_shadow.visible = !player.lit and !game_over
	texture_hidden.visible = player.lit and player.obscured and !game_over
	var loot_target_pos : float = 16.0 if loot_show_time > 0.0 else -16.0
	var objective_target_pos : float = 688.0 if objective_show_time > 0.0 else 752.0
	if loot_show_time > 0.0: loot_show_time -= delta
	if objective_show_time > 0.0: objective_show_time -= delta
	loot.position.y = lerp(loot.position.y, loot_target_pos, MOVE_SPEED * delta)
	objective.position.y = lerp(objective.position.y, objective_target_pos, MOVE_SPEED * delta)
	if game_over:
		grey_amount = clampf(grey_amount + delta, 0.0, 1.0)
		greyout.material.set_shader_parameter("amount", grey_amount)

func _ready() -> void:
	greyout.material.set_shader_parameter("amount", grey_amount)
