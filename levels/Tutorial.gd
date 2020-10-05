extends "res://levels/Level.gd"

func _on_Tutorial_level_ended():
	var _unused = get_tree().change_scene("res://Main.tscn")
