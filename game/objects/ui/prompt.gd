@tool
extends HBoxContainer

const ICON_WIDTH : int = 64

@export var title : String = "Action Name" :
	set(value):
		if has_node("Label_Action"):
			$Label_Action.text = value
			title = value

@export var action_name : String

@onready var key : Label = $Label_Key
@onready var button : TextureRect = $Texture_Button

func refresh() -> void:
	var keycode : int = Settings.get_keybinding(action_name)
	var keyname : String = OS.get_keycode_string(keycode)
	$Label_Key.text = "[" + keyname + "]"
	var joycode : int = Settings.get_joybinding(action_name)
	var joy_offset : int = Settings.JOY_BUTTON_ICON[joycode]
	button.texture.region.position.x = joy_offset * ICON_WIDTH
	if Settings.last_input_was_controller:
		button.show()
		key.hide()
	else:
		button.hide()
		key.show()

func _ready() -> void:
	button.texture = button.texture.duplicate(true)
	refresh()
