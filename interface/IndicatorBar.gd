extends Control

export var maximun = 100
export var minimun = 0
var current = 100

onready var fill = get_node("Fill")
onready var fill_width = fill.texture.get_size()[0]

func _ready():
	_update_bar()

func _update_bar():
	var new_width = int(float(current)/float(maximun)*fill_width)
	fill.set_custom_minimum_size(Vector2(new_width, 60))

func set_current(new_value):
	current = new_value
	_update_bar()
