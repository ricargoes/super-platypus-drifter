extends Node2D

export var scroll_speed = 10.0
onready var camera_start = get_node("CameraStart")
var camera = null
onready var ship_start = get_node("ShipStart")
var ship = null

func _ready():
	# Load BG
	var background = SPD.BACKGROUND_SCENE.instance()
	add_child(background)
	move_child(background, 0)

	_reset_game()
	set_process(true)

func _reset_game():
	# Initial position for the camera
	camera = Camera2D.new()
	camera.current = true
	camera.position = camera_start.position
	add_child(camera)

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
