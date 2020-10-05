extends Area2D

export var sequence_name = "start"
var enable = true

func _on_Activator_body_entered(body):
	if enable:
		var gui = body.get_node("ShipGUI/Conversations")
		gui.begin_conversation(sequence_name)
		enable = false
