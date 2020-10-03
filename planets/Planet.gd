extends StaticBody2D

export var orbit_speed = 2*PI/10
const BREAK_AMOUNT = 1000

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var ships = $Orbit.get_overlapping_bodies()
	for ship in ships:
		var ship_from_planet = ship.position - position
		var r = ship_from_planet.length()
		var orbital_speed = r*orbit_speed
		if ship.is_lock:
			var angle = ship_from_planet.angle()
			ship.position = position + r*Vector2(cos(angle+orbit_speed*delta), sin(angle+orbit_speed*delta))
			ship.speed = Vector2(cos(ship.rotation), sin(ship.rotation))*orbital_speed
		if ship.speed.length() < orbital_speed:
			ship.is_lock = true
		else:
			ship.speed -= BREAK_AMOUNT * delta * ship.speed.normalized()


func _on_Orbit_body_exited(body):
	body.is_lock = false
