extends CanvasLayer

@export_node_path("Node2D") var path_player
@onready var player : Node2D = get_node(path_player)

@onready var texture_in_light : TextureRect = $Texture_InLight
@onready var texture_in_shadow : TextureRect = $Texture_InShadow
@onready var texture_hidden : TextureRect = $Texture_Hidden
@onready var label_loot_value : Label = $Label_Loot_Value

func update_loot_value(loot : int) -> void:
	label_loot_value.text = "$" + str(loot)

func _physics_process(delta : float) -> void:
	texture_in_light.visible = player.lit and !player.obscured
	texture_in_shadow.visible = !player.lit
	texture_hidden.visible = player.lit and player.obscured
