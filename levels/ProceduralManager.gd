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
export(int) var density_change_distance = 1960
export(float) var density_change_ammount = 0.1

export(float) var initial_tunnel_widht = 560
export(int) var tunnel_widht_change_distance = 1960
export(float) var tunnel_widht_change_ammount = 10
export(int) var tunnel_widht_change_minimun = 150

export(GOODLUCK_OPTIONS) var goodluck = 0

# Locals
onready var camera = $"../Camera"
onready var starting_position = camera.position.x
onready var last_cell = int(camera.position.x) % int(SPD.LEVEL_WIDTH)
var relative_position = null
var current_density = initial_density
var current_tunnel_width = initial_tunnel_widht
var current_cell = null

# Update script locals
func _update_locals():
	relative_position = camera.position.x - starting_position
	current_cell = int(int(relative_position) / SPD.LEVEL_WIDTH)
	current_density = initial_density + abs(
		int(relative_position / density_change_distance)
		* density_change_ammount
	)
	current_tunnel_width = initial_tunnel_widht + abs(
		int(relative_position / tunnel_widht_change_distance)
		* tunnel_widht_change_ammount
	)
	current_tunnel_width = \
		max(current_tunnel_width, tunnel_widht_change_minimun)

func _new_cell(cell_number):
	# TODO: Handle cell generation
	print(
		"Generating cell " + str(cell_number)
		+ " with density " + str(current_density)
		+ " and tunnel width " + str(current_tunnel_width) + " .")
	return Cell.new()

func _clear_cell(cell):
	for entity in cell.entities:
		entity.free()
		print("Cleared.")

func _init_cells():
	for cell in cells:
		_clear_cell(cell)
	cells = []
	cells.push_back(_new_cell(current_cell-2))
	cells.push_back(_new_cell(current_cell-1))
	cells.push_back(_new_cell(current_cell))
	cells.push_back(_new_cell(current_cell+1))
	cells.push_back(_new_cell(current_cell+2))

func _ready():
	_update_locals()
	_init_cells()
	set_process(true)

func _shift_cells(backwards=false):
	if not backwards:
		print("Clearing cell " + str(current_cell - 3))
		_clear_cell(cells[0])
		cells = [cells[1], cells[2], cells[3], cells[4]]
		cells.push_back(_new_cell(current_cell + 2))
	else:
		print("Clearing cell " + str(current_cell + 3))
		_clear_cell(cells[4])
		cells = [cells[0], cells[1], cells[2], cells[3]]
		cells.push_front(_new_cell(current_cell - 2))

func _process(_delta):
	_update_locals()

	# Cell shifting and generation
	while current_cell > last_cell:
		_shift_cells()
		last_cell += 1
	while current_cell < last_cell:
		_shift_cells(true)
		last_cell -= 1
