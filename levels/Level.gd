extends Node2D

export var scroll_speed = 10.0
var camera = null
var ship = null

func _ready():
	_reset_game()
	set_process(true)

func _reset_game():
	# Initial position for the camera
	var camera_start = get_node("CameraStart")
	camera = Camera2D.new()
	camera.current = true
	camera.position = camera_start.position
	add_child(camera)

	# Initial position for the ship
	var ship_start = get_node("ShipStart")
	ship = SPD.SHIP_SCENE.instance()
	ship.position = ship_start.position
	add_child(ship)

func _process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	if ship:
		_update_game_state(delta)
	else:
		_reset_game()

func _update_game_state(delta):
	# Ship warp
	if ship.position.y < 0: ship.position.y = ship.position.y + SPD.LEVEL_HEIGHT
	if ship.position.y > 1080: ship.position.y = ship.position.y - SPD.LEVEL_HEIGHT