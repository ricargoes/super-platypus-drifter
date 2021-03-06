extends Node


export(bool) var enabled = true
onready var root = $".."


func _ready():
	set_physics_process(true)


func _physics_process(_delta):
	if enabled:
		if root.position.y < 0:
			root.position.y = root.position.y + SPD.LEVEL_HEIGHT
		if root.position.y > SPD.LEVEL_HEIGHT:
			root.position.y = root.position.y - SPD.LEVEL_HEIGHT
