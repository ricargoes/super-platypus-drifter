extends Node2D

export var maximun = 100
export var minimun = 0
var current = 100

onready var fill = get_node("Fill")

func _ready():
	_update_bar()

func _update_bar():
	var new_width = int(float(current)/float(maximun)*240.0)
	fill.set_region_rect(Rect2(0, 0, new_width, 60))

func set_current(new_value):
	current = new_value
	_update_bar()
