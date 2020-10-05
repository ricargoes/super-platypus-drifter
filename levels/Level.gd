extends Node2D

export var scroll_speed = 100.0
onready var camera_start = $CameraStart
onready var camera = $Camera
onready var ship_start = $ShipStart
var ship = null

signal level_ended

func _ready():
	# Initial position for the camera
	camera.position = camera_start.position

	# Initial position for the ship
	ship = SPD.SHIP_SCENE.instance()
	ship.position = ship_start.position
	add_child(ship)
	set_physics_process(true)

func _physics_process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	if ship:
		_update_game_state()
	else:
		SPD.journey_length = int(camera.position.x/100)
		game_over()

func _update_game_state():

	# Ship killed by level limits
	var ship_camera_displacement = ship.position.x - camera.position.x
	if ship_camera_displacement < -SPD.LEVEL_WIDTH/2:
		ship.die()
	if ship_camera_displacement > SPD.LEVEL_WIDTH/2:
		ship.die()


func _on_Endline_body_entered(body):
	emit_signal("level_ended")

func game_over():
	var _unused = get_tree().change_scene("res://levels/GameOver.tscn")
