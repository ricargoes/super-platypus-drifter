extends Node

# Constants
var LEVEL_HEIGHT = 1080
var LEVEL_WIDTH = 1920
var MAX_SCREENS = 1000

# Preloaded scenes
var SHIP_SCENE = preload("res://actors/Ship.tscn")
var BACKGROUND_SCENE = preload("res://levels/Background.tscn")

# Space entities enum
enum SPACE_ENTITIES {
	PLANET,
	ASTEROID,
	BLACKHOLE,
	BOMBPLANET,
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
		preload("res://actors/Asteroid.tscn"), 0.3),
	SPACE_ENTITIES.BLACKHOLE: SpaceEntityInfo.new(
		preload("res://actors/BlackHole.tscn"), 0.3),
	SPACE_ENTITIES.BOMBPLANET: SpaceEntityInfo.new(
		preload("res://planets/BombPlanet.tscn"), 0.9),
}

var PLANET_ENTITIES_INFO = {
	SPACE_ENTITIES.FUELCAN: SpaceEntityInfo.new(
		preload("res://powerups/FuelCan.tscn"), 0.8),
	SPACE_ENTITIES.DARKENERGY: SpaceEntityInfo.new(
		preload("res://powerups/DarkEnergy.tscn"), 0.95),
}
