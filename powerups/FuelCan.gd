extends Area2D


export var fuel_amount = 20


func _on_FuelCan_body_entered(body):
	body.refill_fuel(fuel_amount)
	queue_free()
