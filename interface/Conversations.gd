extends Popup

var sequence = []
var counter = -1

onready var textures = {
	SPD.Speakers.Pilot: preload("res://interface/characters/billyduck_anim.tres"),
	SPD.Speakers.Council: preload("res://interface/characters/council_member_anim.tres"),
	SPD.Speakers.Dingo: preload("res://interface/characters/dingo_django_anim.tres"),
	SPD.Speakers.Royal: preload("res://interface/characters/platypuness_anim.tres"),
}

onready var textures_still = {
	SPD.Speakers.Pilot: preload("res://interface/characters/Billy Duck1.png"),
	SPD.Speakers.Council: preload("res://interface/characters/Council Member1.png"),
	SPD.Speakers.Dingo: preload("res://interface/characters/Evil Dingo Django1.png"),
	SPD.Speakers.Royal: preload("res://interface/characters/Your Platypuness1.png"),
}

onready var audios = {
	SPD.Speakers.Pilot: preload("res://interface/characters/pilot.wav"),
	SPD.Speakers.Council: preload("res://interface/characters/council.wav"),
	SPD.Speakers.Dingo: preload("res://interface/characters/dingo.ogg"),
	SPD.Speakers.Royal: preload("res://interface/characters/royal.wav"),
}

func _input(event):
	if event.is_action_released("ui_accept") and visible:
		next()

func begin_conversation(sequence_name):
	get_tree().paused = true
	sequence = SPD.CONVERSATION_SEQUENCES[sequence_name]
	counter = -1
	next()
	popup()
	set_process_input(true)

func refresh():
	$Speak.stop()
	$Margins/BG/MarginContainer/HBoxContainer/TextEdit.text = sequence[counter]["text"]
	if "silent" in sequence[counter] and sequence[counter]["silent"]:
		$Margins/BG/MarginContainer/HBoxContainer/TextureRect.texture = textures_still[sequence[counter]["speaker"]]
	else:
		$Margins/BG/MarginContainer/HBoxContainer/TextureRect.texture = textures[sequence[counter]["speaker"]]
		$Speak.stream = audios[sequence[counter]["speaker"]]
		$Speak.play()
	show()

func next():
	counter += 1
	if counter >= sequence.size():
		end()
	else:
		refresh()

func end():
	$Speak.stop()
	hide()
	get_tree().paused = false
