extends Node

export var level = 1

var levels_scene = [
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn")
]

func _ready():
	var level_scene = levels_scene[level-1].instance()
	add_child(level_scene)
