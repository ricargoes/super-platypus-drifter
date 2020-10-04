extends "res://planets/Planet.gd"

var textures = [
	preload("res://planets/planet1.png"), 
	preload("res://planets/planet2.png"), 
	preload("res://planets/planet3.png"),
	preload("res://planets/planet5.png"),
	preload("res://planets/planet6.png"),
]

export var random_texture = true
export var texture_number = 0

func _ready():
	var index
	if random_texture:
		randomize()
		index = randi() % textures.size()
	else:
		index = texture_number
		
	$Sprite.texture = textures[index]
