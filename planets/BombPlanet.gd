extends "res://planets/Planet.gd"

export var countdown = 5.0

func _ready():
	$BombAnim.speed_scale = 1.0/countdown

func _on_Orbit_body_entered(body):
	if not $BombAnim.playing: $BombAnim.play()

func _on_BombAnim_animation_finished():
	$BombAnim.hide()
	$ExplosionAnim.show()
	var bodies = $Orbit.get_overlapping_bodies()
	for body in bodies:
		body.die()
	$ExplosionAnim.play()

func _on_ExplosionAnim_animation_finished():
	queue_free()
