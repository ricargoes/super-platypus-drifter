extends Node2D

export var scroll_speed = 100.0
onready var camera_start = $CameraStart
onready var camera = $Camera
onready var ship_start = $ShipStart
export var do_witty_comments = true
var ship = null

signal level_ended

func _ready():
	# Initial position for the camera
	camera.position = camera_start.position

	# Initial position for the ship
	ship = weakref(SPD.SHIP_SCENE.instance())
	ship.get_ref().position = ship_start.position
	if not do_witty_comments: ship.get_ref().get_node("Bubble/WittyComment").queue_free()
	add_child(ship.get_ref())
	set_physics_process(true)

func _physics_process(delta):
	camera.global_translate(Vector2(scroll_speed * delta, 0))
	if ship and ship.get_ref():
		_update_game_state()
	else:
		SPD.journey_length = int(camera.position.x/100)
		game_over()

func _update_game_state():

	# Ship killed by level limits
	var ship_camera_displacement = ship.get_ref().position.x - camera.position.x
	if ship_camera_displacement < -SPD.LEVEL_WIDTH/2:
		ship.get_ref().die()
	if ship_camera_displacement > SPD.LEVEL_WIDTH/2:
		ship.get_ref().die()


func _on_Endline_body_entered(body):
	emit_signal("level_ended")

func game_over():
	var _unused = get_tree().change_scene("res://levels/GameOver.tscn")

func artifact_found(body):
	SPD.artifacts[SPD.current_level] = true
