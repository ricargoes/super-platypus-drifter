extends Node


export(String) var sprite_name = 'Sprite'
onready var sprite = get_node('../' + sprite_name)
var top_ghost = null
var bottom_ghost = null

func _ready():
	if sprite is Sprite or sprite is AnimatedSprite:
		top_ghost = sprite.duplicate()
		sprite.add_child(top_ghost)
		bottom_ghost = sprite.duplicate()
		sprite.add_child(bottom_ghost)
	set_physics_process(true)

func _physics_process(_delta):
	if sprite is Sprite or sprite is AnimatedSprite:
		if sprite is Sprite:
			if top_ghost.texture != sprite.texture:
				top_ghost.texture = sprite.texture
		top_ghost.flip_h = sprite.flip_h
		top_ghost.flip_v = sprite.flip_v
		top_ghost.set_rotation(sprite.get_rotation())
		top_ghost.set_global_position(Vector2(
			sprite.global_position.x, 
			sprite.global_position.y - SPD.LEVEL_HEIGHT
		))
		if sprite is Sprite:
			if bottom_ghost.texture != sprite.texture:
				bottom_ghost.texture = sprite.texture
		top_ghost.flip_h = sprite.flip_h
		top_ghost.flip_v = sprite.flip_v
		bottom_ghost.set_rotation(sprite.get_rotation())
		bottom_ghost.set_global_position(Vector2(
			sprite.global_position.x, 
			sprite.global_position.y + SPD.LEVEL_HEIGHT
		))
		if sprite is AnimatedSprite:
			top_ghost.frame = sprite.frame
			bottom_ghost.frame = sprite.frame
