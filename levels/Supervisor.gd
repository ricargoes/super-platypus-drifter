extends Node

export var level = 1

var levels_scene = [
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn")
]

func _ready():
	load_level()

func load_level():
	var level_scene = levels_scene[level-1].instance()
	add_child(level_scene)
	level_scene.connect("level_ended", self, "next_level")

func next_level():
	level += 1
	load_level()
