extends "res://planets/Planet.gd"

func _ready():
	$LightningAnim.scale *= planet_scale
	$LightningAnim.position *= planet_scale
