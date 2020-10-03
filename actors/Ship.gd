extends KinematicBody2D

export var ACCELERATION = 1000
export var TURN_SPEED = 5
export var MAX_BOOST_CHARGE = 50
export var BOOST_CHARGE_RATE = 30
export var MAX_FUEL = 100
export var FUEL_PER_CHARGE = 0.2
var speed = Vector2(0, 0)
var is_lock = false
var boost_charge = 0
var fuel = 30

func _ready():
	$ShipGUI/Box/BoostBar.max_value = MAX_BOOST_CHARGE
	$ShipGUI/Box/FuelBar.max_value = MAX_FUEL
	set_physics_process(true)
	set_process(true)

func _process(_delta):
	gui_update()

func _physics_process(delta):
	pilot(delta)
	if is_lock:
		return
	
	var kinematic_collision = move_and_collide(speed*delta)
	if kinematic_collision:
		die()

func gui_update():
	$ShipGUI/Box/BoostBar.value = boost_charge
	$ShipGUI/Box/FuelBar.value = fuel

func die():
	queue_free()

func pilot(delta):
	if Input.is_action_pressed("ship_boost"):
		charge_boost(delta)
	elif Input.is_action_just_released("ship_boost"):
		boost()
		$BoosterAnim.hide()
		

	if Input.is_action_pressed("ship_turn_left"):
		rotation -= TURN_SPEED*delta
	elif Input.is_action_pressed("ship_turn_right"):
		rotation += TURN_SPEED*delta

func charge_boost(delta):
	if fuel == 0:
		return
	$BoosterAnim.show()
	$BoosterAnim.play()
	boost_charge += BOOST_CHARGE_RATE*delta
	if boost_charge >= MAX_BOOST_CHARGE:
		boost()

func boost():
	speed += ACCELERATION*Vector2(cos(rotation), sin(rotation))*boost_charge/MAX_BOOST_CHARGE
	fuel = max(fuel - FUEL_PER_CHARGE*boost_charge, 0)
	boost_charge = 0
	is_lock = false
	$OrbitalUnlock.start()

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

func refill_fuel(fuel_amount):
	fuel = min(fuel+fuel_amount, MAX_FUEL)

func is_orbitally_unlocked():
	return not $OrbitalUnlock.is_stopped()
