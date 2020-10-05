extends Node

var levels_scene = [
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level2.tscn"),
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level1.tscn")
]
var current_levels_scene = null

func _ready():
	load_level()

func load_level():
	if current_levels_scene: current_levels_scene.queue_free()
	current_levels_scene = levels_scene[SPD.current_level-1].instance()
	add_child(current_levels_scene)
	current_levels_scene.connect("level_ended", self, "next_level")

func next_level():
	SPD.level += 1
	load_level()

