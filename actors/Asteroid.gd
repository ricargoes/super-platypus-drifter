extends StaticBody2D

var rotation_speed = 0.1

func _ready():
	set_process(true)

func _process(delta):
	rotate(delta * rotation_speed)
