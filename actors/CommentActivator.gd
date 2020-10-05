extends Area2D

export(String, MULTILINE) var bubble_text = "start"
var enable = true

func _on_Activator_body_entered(body):
	if enable:
		body.show_bubble(bubble_text)
		enable = false
