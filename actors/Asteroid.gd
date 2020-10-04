extends RigidBody2D

export var random_velocity = false
export var velocity = Vector2(0,0)

func _ready():
	randomize()
	angular_velocity = (randf()-0.5)*10
	if random_velocity:
		velocity = Vector2(randf() - 0.5, randf() - 0.5)*120
	
	linear_velocity = velocity



func _on_Asteroid_body_entered(body):
	if body in get_tree().get_nodes_in_group("planets"): destroy()

func destroy():
	queue_free()
