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

enum Speakers { Pilot, Council, Dingo, Royal }

var CONVERSATION_SEQUENCES = {
	"level1_start": [
		{"speaker": Speakers.Royal, "text": "Hemos encontrado un artefacto ancestral, debes de encontrar dos más para que la verdad sea revelada..."},
		{"speaker": Speakers.Pilot, "text": "Si vale, pero ¿por qué tengo el depósito de combustible casi vacío?"},
		{"speaker": Speakers.Council, "text": "Recortes presupuestarios"},
		{"speaker": Speakers.Pilot, "text": "Pero si su majestad lleva un monóculo de oro!!!"},
		{"speaker": Speakers.Royal, "text": "...", "silent": true},
		{"speaker": Speakers.Council, "text": "...", "silent": true},
		{"speaker": Speakers.Pilot, "text": "...", "silent": true},
		{"speaker": Speakers.Council, "text": "Ajem, seguiremos en contacto"},
	],
	"level1_end1": [
		{"speaker": Speakers.Pilot, "text": "Tendré que apurar el próximo salto!!!"},
	],
	"level1_end2": [
		{"speaker": Speakers.Pilot, "text": "Cogeré esa unidad de materia oscura para salir de este sector galáctico."},
	],
	"lore1": [
		{"speaker": Speakers.Royal, "text": "Ahí!!!, en ese planeta!!!"},
		{"speaker": Speakers.Council, "text": "EL ARTEFACTO"},
		{"speaker": Speakers.Pilot, "text": "No va a ser fácil entrar ahí..."},
		{"speaker": Speakers.Royal, "text": "Te ordeno que entres en la órbita!!!"},
		
	],
	"lore2": [
		{"speaker": Speakers.Pilot, "text": "Lo tengo!!!"},
		
	],
}
