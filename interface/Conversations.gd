extends MarginContainer

enum Speakers { Pilot, Council, Dingo, Royal }

var sequence = [
	{"speaker": Speakers.Pilot, "text": "tutupa"},
	{"speaker": Speakers.Royal, "text": "chaca"},
]

var counter = 0

onready var textures = {
	Speakers.Pilot: preload("res://interface/characters/billyduck_anim.tres"),
	Speakers.Council: preload("res://interface/characters/council_member_anim.tres"),
	Speakers.Dingo: preload("res://interface/characters/dingo_django_anim.tres"),
	Speakers.Royal: preload("res://interface/characters/platypuness_anim.tres"),
}

func _input(event):
	if event.is_action_released("ui_accept") and visible:
		next()

func begin_conversation():
	counter = 0
	refresh()
	set_process_input(true)

func refresh():
	$Conversations/MarginContainer/HBoxContainer/TextureRect.texture = textures[sequence[counter]["speaker"]]
	$Conversations/MarginContainer/HBoxContainer/TextEdit.text = sequence[counter]["text"]
	show()

func next():
	counter += 1
	if counter >= sequence.size():
		end()
	else:
		refresh()

func end():
	hide()
