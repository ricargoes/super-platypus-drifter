extends StaticBody2D

var orbit_speed = PI/10
const CATCHING_SPEED = 30

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var ships = $Orbit.get_overlapping_bodies()
	for ship in ships:
		if ship.is_lock:
			var ship_from_planet = ship.position - position
			var r = ship_from_planet.length()
			var angle = ship_from_planet.angle()
			
			ship.position = position + r*Vector2(cos(angle+orbit_speed*delta), sin(angle+orbit_speed*delta))
			ship.orienting_to(ship_from_planet.angle()+ PI/2, delta)
			ship.speed = Vector2(cos(ship.rotation), sin(ship.rotation))*CATCHING_SPEED
		elif not ship.is_unrestricted():
			if ship.speed.length() < CATCHING_SPEED:
				ship.is_lock = true
			else:
				ship.speed = ship.speed * 0.1


func _on_Orbit_body_exited(body):
	body.is_lock = false
