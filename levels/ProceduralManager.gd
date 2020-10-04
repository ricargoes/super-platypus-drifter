extends Node

# This script spawns and destroys space elements as the player moves to the
# right. It expects a "Camera" sibling to determine the current level position.
# The scripts considers the level as a series of separated "cells" with the
# width of a game screen. To handle spawning and clearing, an array of 5 cells
# is kept. Each cell has a a list to hold the entities spawned inside it and
# other fields to determine the spawning algorithm.

enum CELL_STYLES {

	# Form followed by the cleared area in the screen (space ensured empty)
	TUNNEL = 0,   # A strip in the middle of the screen
	SIN = 1,      # A sine wave
	SAW = 2,      # A saw (back an forth diagonally from top to bottom)
	GOODLUCK = 3, # Disable the ensured space

	# Vertical position for the cleared area
	MIDDLE = -1,
	TOP = 0,
	BOTTOM = 1,

}

# Disable or enable the GOODLUCK cell style
enum GOODLUCK_OPTIONS {
	DISABLED,
	ENABLED,
}

class Cell:
	var cell_style = 0
	var style_height = 0
	var entities = []
	func _init(
		initial_cell_style = CELL_STYLES.TUNNEL,
		initial_style_height = CELL_STYLES.MIDDLE
	):
		self.cell_style = initial_cell_style
		self.style_height = initial_style_height

# Store the two previous cells, the current cell and the next two cells
var cells = []

# Editor configuration with defaul values
export(float) var initial_density = 1
export(int) var density_width = 1960
export(float) var density_increments = 0.1
export(GOODLUCK_OPTIONS) var goodluck = 0

# Locals
onready var current_density = initial_density
onready var camera = $"../Camera"
onready var starting_position = camera.position.x
onready var last_cell = int(camera.position.x) % int(SPD.LEVEL_WIDTH)

# Called when the node enters the scene tree for the first time.
func _ready():
	cells = [
		_new_cell(),
		_new_cell(),
		_new_cell(),
		_new_cell(),
		_new_cell(),
	]
	set_process(true)

func _shift_cells(backwards=false):
	if not backwards:
		cells = [cells[1], cells[2], cells[3], cells[4]]
		cells.push_back(_new_cell())
	else:
		cells = [cells[0], cells[1], cells[2], cells[3]]
		cells.push_front(_new_cell())

func _new_cell(): return Cell.new()

func _process(delta):
	var relative_position = starting_position - camera.position.x

	# Update density
	current_density = initial_density + abs(
		int(relative_position / density_width) * density_increments
	)
	print(current_density)

	# Cell generation
	var cell_number = int(relative_position) % int(SPD.LEVEL_WIDTH)
	while cell_number > last_cell:
		_shift_cells()
		last_cell += 1
	while cell_number < last_cell:
		_shift_cells(true)
		last_cell -= 1
