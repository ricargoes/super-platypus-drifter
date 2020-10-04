extends Sprite

func _ready():
	var root = get_node(".")
	root.set_region_rect(Rect2(
		0, 0, SPD.MAX_SCREENS * SPD.LEVEL_WIDTH, SPD.LEVEL_HEIGHT)
	)
	root.global_translate(Vector2(-SPD.LEVEL_WIDTH/2, 0))
