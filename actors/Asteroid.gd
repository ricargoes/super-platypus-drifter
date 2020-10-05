extends RigidBody2D

export var random_velocity = false
export var velocity = Vector2(0,0)
var selected_asteroid = null

func _ready():
	randomize()
	var asteroid_variants = [
		get_node("CollisionShape2D1"),
		get_node("CollisionShape2D2"),
		get_node("CollisionShape2D3"),
		get_node("CollisionShape2D4"),
	]
	var _index = randi() % asteroid_variants.size()
	for i in range(asteroid_variants.size()):
		if i == _index:
			selected_asteroid = asteroid_variants[i]
		else:
			asteroid_variants[i].queue_free()
	
	angular_velocity = (randf()-0.5)*10
	if random_velocity:
		velocity = Vector2(randf() - 0.5, randf() - 0.5)*120
	
	if velocity: linear_velocity = velocity

func _on_Asteroid_body_entered(body):
	if body in get_tree().get_nodes_in_group("planets"): destroy()
	if body.has_method("die"): body.die()

func destroy():
	set_collision_mask(0)
	set_collision_layer(0)
	selected_asteroid.get_node("Sprite").hide()
	selected_asteroid.get_node("AnimatedSprite").show()
	selected_asteroid.get_node("AnimatedSprite").play()

func disappear():
	queue_free()
