extends Control


func _ready():
	$Main/Tutorial.grab_focus()

func _on_Tutorial_pressed():
	SPD.current_level = 0
	var _unused = get_tree().change_scene("res://levels/Tutorial.tscn")

func _on_Endless_pressed():
	SPD.current_level = -1
	var _unused = get_tree().change_scene("res://levels/ProceduralLevel.tscn")

func _on_Story_pressed():
	SPD.do_conversations = $Main/DoConversations.pressed
	SPD.current_level = 1
	SPD.artifacts = {
		1: false,
		2: false,
		3: false
	}
	var _unused = get_tree().change_scene("res://levels/Supervisor.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func set_explanation(text):
	$Main/HSeparator/Margin/HBoxContainer/TextEdit.text = text

func default_explanation():
	set_explanation("Pick your poison!")

func _on_Tutorial_mouse_entered():
	set_explanation("Learn to play")

func _on_Endless_mouse_entered():
	set_explanation("How far can you get?")

func _on_Story_mouse_entered():
	set_explanation("A platypus chronicle")

func _on_Quit_mouse_entered():
	set_explanation("Don't go!      :'(")
