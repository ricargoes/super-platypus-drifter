extends CenterContainer

var good_win = true

func _ready():
	for level in SPD.artifacts.keys():
		if not SPD.artifacts[level]:
			good_win = false
	
	var text_edit = $VBoxContainer/NinePatchRect/MarginContainer/TextEdit
	if good_win:
		text_edit.text = "You have collected my artifacts, I will used them now to replenish my power and place you in the next step of evolution. It will mark the dawn of a new age."
		$VBoxContainer/HBoxContainer2/Retry.hide()
	else:
		$VBoxContainer/Label.text += "?"
		text_edit.text = "You have failed to gather my blessings. Now go to the beginning! I will send you back on time so you can collect all my artifacts."

func _on_Retry_pressed():
	SPD.current_level = 3
	SPD.artifacts = {
		1: false,
		2: false,
		3: false
	}
	var _unused = get_tree().change_scene("res://levels/Supervisor.tscn")

func _on_MainMenu_pressed():
	var _unused = get_tree().change_scene("res://Main.tscn")
