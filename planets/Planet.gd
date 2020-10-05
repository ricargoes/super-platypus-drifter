extends StaticBody2D

export var orbit_speed = 2*PI/10
export var planet_scale = 1.0
const BREAK_AMOUNT = 1000

func _ready():
	$Sprite.scale *= planet_scale
	$OrbitalRing.scale *= planet_scale
	var planet_shape = CircleShape2D.new()
	planet_shape.radius = $CollisionShape2D.shape.radius*planet_scale
	$CollisionShape2D.shape = planet_shape
	var orbit_shape = CircleShape2D.new()
	orbit_shape.radius = $Orbit/CollisionShape2D.shape.radius*planet_scale
	$Orbit/CollisionShape2D.shape = orbit_shape
	set_physics_process(true)

func _physics_process(delta):
	$OrbitalRing.flip_h = true if orbit_speed > 0 else false
	$OrbitalRing.rotate(orbit_speed*delta)
	var ships = $Orbit.get_overlapping_bodies()
	for ship in ships:
		if ship.is_orbitally_unlocked():
			continue
		
		var ship_from_planet = ship.position - position
		var r = ship_from_planet.length()
		var orbital_speed = r*orbit_speed
		if ship.is_lock:
			var angle = ship_from_planet.angle()
			ship.position = position + r*Vector2(cos(angle+orbit_speed*delta), sin(angle+orbit_speed*delta))
			ship.speed = Vector2(cos(angle+sign(orbit_speed)*PI/2), sin(angle+sign(orbit_speed)*PI/2))*orbital_speed
		if ship.speed.length() < abs(orbital_speed):
			ship.is_lock = true
			if ship.has_node('Wrapper'):
				ship.get_node('Wrapper').enabled = false
		else:
			ship.speed -= BREAK_AMOUNT * delta * ship.speed.normalized()

func _on_Orbit_body_exited(body):
	body.is_lock = false
	if body.has_node('Wrapper'):
		body.get_node('Wrapper').enabled = true
