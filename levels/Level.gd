extends Node2D

export var scroll_speed = 40.0
onready var camera_start = get_node("CameraStart")
onready var camera = $Camera
onready var ship_start = get_node("ShipStart")
var ship = null

func _ready():
	# Initial position for the camera
	camera.position = camera_start.position

	# Initial position for the ship
	ship = SPD.SHIP_SCENE.instance()
	ship.position = ship_start.position
	add_child(ship)
	set_process(true)

func _process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	if ship:
		_update_game_state()
	else:
		get_tree().reload_current_scene()

func _update_game_state():

	# Ship killed by level limits
	var ship_camera_displacement = ship.position.x - camera.position.x
	if ship_camera_displacement < -SPD.LEVEL_WIDTH/2:
		ship.die()
	if ship_camera_displacement > SPD.LEVEL_WIDTH/2:
		ship.die()
