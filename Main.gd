extends Control


func _on_Tutorial_pressed():
	pass

func _on_Endless_pressed():
	var _unused = get_tree().change_scene("res://levels/ProceduralLevel.tscn")

func _on_Story_pressed():
	var _unused = get_tree().change_scene("res://levels/Level1.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func set_explanation(text):
	$Main/HSeparator/Margin/HBoxContainer/TextEdit.text = text

func default_explanation():
	set_explanation("Choose mode")

func _on_Tutorial_mouse_entered():
	set_explanation("Learn to play")

func _on_Endless_mouse_entered():
	set_explanation("How far can you get?")

func _on_Story_mouse_entered():
	set_explanation("A platypus chronicle")

func _on_Quit_mouse_entered():
	set_explanation("Don't go!      :'(")
