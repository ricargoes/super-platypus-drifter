extends Control


func _on_Tutorial_pressed():
	pass


func _on_Endless_pressed():
	var _unused = get_tree().change_scene("res://levels/ProceduralLevel.tscn")


func _on_Story_pressed():
	var _unused = get_tree().change_scene("res://levels/Level1.tscn")


func _on_Quit_pressed():
	get_tree().quit()
