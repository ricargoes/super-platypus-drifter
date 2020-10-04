extends Node2D

export var scroll_speed = 10.0
onready var camera_start = get_node("CameraStart")
onready var camera = $Camera
onready var ship_start = get_node("ShipStart")
var ship = null

func _ready():
	_reset_game()
	set_process(true)

func _reset_game():
	# Initial position for the camera
	camera.position = camera_start.position

	# Initial position for the ship
	ship = SPD.SHIP_SCENE.instance()
	ship.position = ship_start.position
	add_child(ship)

func _process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	if ship:
		_update_game_state()
	else:
		_reset_game()

func _update_game_state():
	# Ship warp
	if ship.position.y < 0: ship.position.y = ship.position.y + SPD.LEVEL_HEIGHT
	if ship.position.y > 1080: ship.position.y = ship.position.y - SPD.LEVEL_HEIGHT

	# Ship killed by level limits
	var ship_camera_displacement = ship.position.x - camera.position.x
	if ship_camera_displacement < -SPD.LEVEL_WIDTH/2:
		ship.die()
	if ship_camera_displacement > SPD.LEVEL_WIDTH/2:
		ship.die()
