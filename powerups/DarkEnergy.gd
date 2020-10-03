extends Area2D

export var infifuel_time = 5

func _ready():
	$AnimatedSprite.play()

func _on_DarkEnergy_body_entered(body):
	body.use_infifuel(infifuel_time)
	queue_free()
