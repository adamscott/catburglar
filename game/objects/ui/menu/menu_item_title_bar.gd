@tool
extends HBoxContainer

@export var title : String = "Menu Title" :
	set(value):
		$Label.text = value
		title = value

var skip_cursor : bool = true
