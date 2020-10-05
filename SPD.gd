extends Node

# Constants
var LEVEL_HEIGHT = 1080
var LEVEL_WIDTH = 1920
var MAX_SCREENS = 1000

# Preloaded scenes
var SHIP_SCENE = preload("res://actors/Ship.tscn")

# Space entities enum
enum SPACE_ENTITIES {
	PLANET,
	ASTEROID,
	BLACKHOLE,
	BOMBPLANET,
	LIGHTINGPLANET,
	FUELCAN,
	DARKENERGY,
}

# Space info type
class SpaceEntityInfo:
	var scene = null
	var rarity = null
	func _init(initial_scene, initial_rarity):
		self.scene = initial_scene
		self.rarity = initial_rarity

# Space entities info data
var SPACE_ENTITIES_INFO = {
	SPACE_ENTITIES.PLANET: SpaceEntityInfo.new(
		preload("res://planets/Planet.tscn"), 0),
	SPACE_ENTITIES.ASTEROID: SpaceEntityInfo.new(
		preload("res://actors/Asteroid.tscn"), 0.5),
	SPACE_ENTITIES.BLACKHOLE: SpaceEntityInfo.new(
		preload("res://actors/BlackHole.tscn"), 0.75),
	SPACE_ENTITIES.LIGHTINGPLANET: SpaceEntityInfo.new(
		preload("res://planets/LightningPlanet.tscn"), 0.99),
	SPACE_ENTITIES.BOMBPLANET: SpaceEntityInfo.new(
		preload("res://planets/BombPlanet.tscn"), 0.99),
}

# Space entities info data for planets
var PLANET_ENTITIES_INFO = {
	SPACE_ENTITIES.FUELCAN: SpaceEntityInfo.new(
		preload("res://powerups/FuelCan.tscn"), 0.2),
	SPACE_ENTITIES.DARKENERGY: SpaceEntityInfo.new(
		preload("res://powerups/DarkEnergy.tscn"), 0.95),
}

var current_level = -1
var journey_length = -1
var artifacts = {
	1: false,
	2: false,
	3: false
}

enum Speakers { Pilot, Council, Dingo, Royal }

var CONVERSATION_SEQUENCES = {
	"level1_start": [
		{"speaker": Speakers.Royal, "text": "Ground Control to Major Bill Duck, we have found an elder artifact. You must find two more for the truth to be revealed..."},
		{"speaker": Speakers.Pilot, "text": "Yes, ok, but... why is my fuel tank almost empty?"},
		{"speaker": Speakers.Council, "text": "Budget cuts, of course."},
		{"speaker": Speakers.Pilot, "text": "But His Platypuness wears a gold monocle!"},
		{"speaker": Speakers.Royal, "text": "...", "silent": true},
		{"speaker": Speakers.Council, "text": "...", "silent": true},
		{"speaker": Speakers.Pilot, "text": "...", "silent": true},
		{"speaker": Speakers.Council, "text": "Ahem, we'll keep in touch."},
	],
	"level1_end1": [
		{"speaker": Speakers.Pilot, "text": "I'll have to rush the next jump!"},
	],
	"level1_end2": [
		{"speaker": Speakers.Pilot, "text": "I'll take that dark matter unit to get out of this galactic sector."},
	],
	
	"lore1": [
		{"speaker": Speakers.Royal, "text": "Look there! On that planet!"},
		{"speaker": Speakers.Council, "text": "THE ARTIFACT"},
		{"speaker": Speakers.Pilot, "text": "Gasp... It won't be easy to get in there..."},
		{"speaker": Speakers.Royal, "text": "Get into its orbit. That's an order!"},
		
	],
	
	"lore2": [
		{"speaker": Speakers.Pilot, "text": "Gotcha'!"},
	],
	
	"level2_end": [
		{"speaker": Speakers.Pilot, "text": "Sensors are detecting something strange and massive in the next sector"},
		{"speaker": Speakers.Royal, "text": "Yes, my minion. We are about to be blessed. Hurry up!"},
	],
	
	"level3_start": [
		{"speaker": Speakers.Dingo, "text": "Don't think about gettin' your ass in there, mate, or y'all cark it!"},
		{"speaker": Speakers.Pilot, "text": "And why should I trust you? Our two species are at war."},
		{"speaker": Speakers.Dingo, "text": "I lost me mates there, boah, if ya cross that line... y'all never come back."},
		{"speaker": Speakers.Pilot, "text": "Ok, I get it. You want to prevent me from getting the artifacts for my people."},
		{"speaker": Speakers.Dingo, "text": "Those artifacts don't exist, mate. Your rulers lie, and mine too. We're just dogs to'em..."},
		{"speaker": Speakers.Pilot, "text": "Well, technically you are a dingo..."},
		{"speaker": Speakers.Dingo, "text": "Shut your hole!"},
		{"speaker": Speakers.Pilot, "text": "...", "silent": true},
		{"speaker": Speakers.Dingo, "text": "...", "silent": true},
		{"speaker": Speakers.Dingo, "text": "Do what ya want, mate. I've already warned you..."},
	],
	
	"level3_bomb":[
		{"speaker": Speakers.Pilot, "text": "A bomb?!?!?!"},
		{"speaker": Speakers.Dingo, "text": "That's it, mate. A bomb planet."},
		{"speaker": Speakers.Pilot, "text": "Well, that doesn't make any sense."},
		
	],
	
	"level3_medium":[
		{"speaker": Speakers.Dingo, "text": "This' the point where I lost all me mates.... Don't be a fool!"},
		{"speaker": Speakers.Pilot, "text": "But... but His Platypuness told me..."},
		{"speaker": Speakers.Royal, "text": "Carry on! I can almost smell the answers to all our questions."},
		{"speaker": Speakers.Pilot, "text": "...", "silent": true},
	],
	
	"lore3": [
		{"speaker": Speakers.Council, "text": "Our scientist think that lightning planet has another sacred artifact."},
		{"speaker": Speakers.Royal, "text": "We need it! I need it!. Go, my minion! Go get it!"},
		{"speaker": Speakers.Pilot, "text": "...", "silent": true},
		{"speaker": Speakers.Dingo, "text": "They're gonna kill ya, mate!"},
	],
	
	"lore4": [
		{"speaker": Speakers.Pilot, "text": "Phew! I did it! Another powerfull artifact for the platypuskind!!"},
	],
	
	"level3_end": [
		{"speaker": Speakers.Pilot, "text": "WTF?"},
		{"speaker": Speakers.Council, "text": "You found it! I cannot believe it! Let's hope you are pure enough!"},
		{"speaker": Speakers.Dingo, "text": "Oh shit!"},
		{"speaker": Speakers.Royal, "text": "Yes! Yeeeees! YEEEEEEEEES! GO! GO, BECOME ONE WITH OUR GOD!"},
	],
}

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
