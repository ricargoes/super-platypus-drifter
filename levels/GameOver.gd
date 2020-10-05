extends CenterContainer

func _ready():
	if SPD.current_level == -1:
		$VBoxContainer/HowFar.text = "Your journey was " + str(SPD.journey_length) + " light-years long"
	else:
		$VBoxContainer/HowFar.text = "Your crash at " + str(SPD.journey_length) + " light-years long in level "+ str(SPD.current_level)


func _on_Retry_pressed():
	if SPD.current_level == -1:
		var _unused = get_tree().change_scene("res://levels/ProceduralLevel.tscn")
	elif SPD.current_level == 0:
		var _unused = get_tree().change_scene("res://levels/Tutorial.tscn")
	elif SPD.current_level > 0:
		var _unused = get_tree().change_scene("res://levels/Supervisor.tscn")
		

func _on_MainMenu_pressed():
	var _unused = get_tree().change_scene("res://Main.tscn")
