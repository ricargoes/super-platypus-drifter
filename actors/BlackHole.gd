extends Area2D

var affected_bodies = []

var sucking_strenght = 2

func _ready():
	get_node("AnimatedSprite").playing = true
	set_process(true)
	
func _process(_delta):
	var body_to_bh = null
	var sucking_factor = null
	for body in affected_bodies:
		if body is Node2D:
			body_to_bh = get_global_position() - body.get_global_position()
			sucking_factor = sucking_strenght / body_to_bh.length()
			body.translate(body_to_bh * sucking_factor)

func _on_BlackHole_body_entered(body):
	if not affected_bodies.has(body):
		affected_bodies.append(body)

func _on_BlackHole_body_exited(body):
	if affected_bodies.has(body):
		affected_bodies.remove(affected_bodies.find(body))
