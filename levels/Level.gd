extends Node2D

export var scroll_speed = 10.0
var camera = null
var ship = null

func _ready():

	# Initial position for the camera
	var camera_start = get_node("CameraStart")
	camera = Camera2D.new()
	camera.current = true
	camera.position = camera_start.position
	camera_start.free()
	add_child(camera)

	# Initial position for the ship
	var ship_start = get_node("ShipStart")
	var ship_node = load("res://actors/Ship.tscn")
	ship = ship_node.instance()
	ship.position = ship_start.position
	ship_start.free()
	add_child(ship)

	# Misc
	set_process(true)

func _process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	print(camera.position)
