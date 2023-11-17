extends VBoxContainer

var current_item : int = 0
var active : bool = false

signal item_selected
signal back

func update_buttons() -> void:
	for i in range(0, get_child_count()):
		get_child(i).modulate = Color.WHITE if current_item == i else Color(1.0, 1.0, 1.0, 0.5)

func change_current_item(diff : int) -> void:
	current_item = wrapi(current_item + diff, 0, get_child_count())
	update_buttons()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("up"):
		change_current_item(-1)
	elif event.is_action_pressed("down"):
		change_current_item(1)
	elif event.is_action_pressed("interact") or event.is_action_pressed("pause"):
		emit_signal("item_selected", get_child(current_item).name)
	elif event.is_action_pressed("shoot"):
		emit_signal("back")

func _ready() -> void:
	update_buttons()
