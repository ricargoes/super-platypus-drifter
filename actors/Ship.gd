extends KinematicBody2D

const ACCELERATION = 30
const TURN_SPEED = 5
var speed = Vector2(0, 0)
var is_lock = false

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	pilot(delta)
	if is_lock:
		return
	
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
		$UnlockedTime.start()
		is_lock = false
	else:
		$BoosterAnim.hide()
	
	if not is_lock:
		if Input.is_action_pressed("ship_turn_left"):
			rotation -= TURN_SPEED*delta
		elif Input.is_action_pressed("ship_turn_right"):
			rotation += TURN_SPEED*delta

func orienting_to(target_angle, delta, tolerance = 0.1):
	var angle_diff = fposmod(get_rotation()-target_angle,2*PI)
	if (abs(angle_diff) < tolerance):
		return true
	else:
		var strength = sqrt(1 - abs(angle_diff/PI - 1))
		if( angle_diff >= 0 and abs(angle_diff) <= PI ) or \
			( angle_diff <= 0 and abs(angle_diff) >= PI ):
			rotation -= TURN_SPEED*delta
		elif( angle_diff <= 0 and abs(angle_diff) <= PI ) or \
			( angle_diff >= 0 and abs(angle_diff) >= PI ):
			rotation += TURN_SPEED*delta
		return false

func is_unrestricted():
	return not $UnlockedTime.is_stopped()
