extends KinematicBody2D

const ACCELERATION = 30
const TURN_SPEED = 5
var speed = Vector2(0, 0)

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	pilot(delta)
	var kinematic_collision = move_and_collide(speed*delta)
	
	if kinematic_collision:
		die()

func die():
	queue_free()


func pilot(delta):
	if Input.is_action_pressed("ship_boost"):
		$BoosterAnim.show()
		$BoosterAnim.play()
		speed += ACCELERATION*delta*Vector2(cos(rotation), sin(rotation))
	else:
		$BoosterAnim.hide()
	
	if Input.is_action_pressed("ship_turn_left"):
		rotation -= TURN_SPEED*delta
	elif Input.is_action_pressed("ship_turn_right"):
		rotation += TURN_SPEED*delta

