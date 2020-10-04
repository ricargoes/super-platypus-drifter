extends Node

# This script spawns and destroys space elements as the player moves to the
# right. It expects a "Camera" sibling to determine the current level position.
# The scripts considers the level as a series of separated "cells" with the
# width of a game screen. To handle spawning and clearing, an array of 5 cells
# is kept. Each cell has a a list to hold the entities spawned inside it and
# other fields to determine the spawning algorithm.

# Form followed by the cleared area in the screen (space ensured empty)
enum CELL_STYLES {
	TUNNEL = 0,   # A strip in the middle of the screen
	SIN = 1,      # A sine wave
	SAW = 2,      # A saw (back an forth diagonally from top to bottom)
	GOODLUCK = 3, # Disable the ensured space
}

# Vertical position for the cleared area
enum CELL_HEIGHTS {
	TOP = -1,
	MIDDLE = 0,
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
export(float) var initial_density = 5
export(int) var density_change_distance = 1960
export(float) var density_change_ammount = 1

export(float) var initial_variety = 1
export(int) var variety_change_distance = 1960
export(float) var variety_change_ammount = 0.5
export(float) var variety_reduction_factor = 1

export(float) var initial_fuel_factor = 0.5
export(int) var fuel_factor_change_distance = 1960
export(float) var fuel_factor_change_ammount = 0

export(float) var initial_tunnel_widht = 320
export(int) var tunnel_widht_change_distance = 1960
export(float) var tunnel_widht_change_ammount = 5
export(int) var tunnel_widht_change_minimun = 120

export(GOODLUCK_OPTIONS) var goodluck = 0

# Locals
onready var rnd = RandomNumberGenerator.new()
onready var root = $".."
onready var camera = $"../Camera"
onready var starting_position = camera.position.x
onready var last_cell = int(camera.position.x) % int(SPD.LEVEL_WIDTH)
var relative_position = null
var current_density = initial_density
var current_variety = initial_variety
var current_fuel_factor = initial_fuel_factor
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
	current_variety = initial_variety + abs(
		int(relative_position / variety_change_distance)
		* variety_change_ammount
	)
	current_fuel_factor = initial_fuel_factor + abs(
		int(relative_position / fuel_factor_change_distance)
		* fuel_factor_change_ammount
	)
	current_tunnel_width = initial_tunnel_widht - abs(
		int(relative_position / tunnel_widht_change_distance)
		* tunnel_widht_change_ammount
	)
	current_tunnel_width = \
		max(current_tunnel_width, tunnel_widht_change_minimun)

func _select_random_entity():
	var adjusted_variety = {}
	for entity_info_key in SPD.SPACE_ENTITIES_INFO.keys():
		adjusted_variety[entity_info_key] = \
			SPD.SPACE_ENTITIES_INFO[entity_info_key].rarity \
			* variety_reduction_factor \
			/ current_variety
	var pool = []
	var roll = rnd.randf()
	for entity in adjusted_variety.keys():
		if adjusted_variety[entity] < roll:
			pool.push_back(entity)
	return pool[rnd.randi_range(0, len(pool)-1)]

func _get_valid_y_coord(cell_info, cell_x):

	if cell_info.cell_style == CELL_STYLES.TUNNEL:
		var top_minimun = 0
		var top_maximun = SPD.LEVEL_HEIGHT / 2 - current_tunnel_width / 2
		var bottom_minimun = SPD.LEVEL_HEIGHT / 2 + current_tunnel_width / 2
		var bottom_maximun = SPD.LEVEL_HEIGHT
		if rnd.randi_range(0, 1) == 0:
			return rnd.randi_range(top_minimun, top_maximun)
		else:
			return rnd.randi_range(bottom_minimun, bottom_maximun)

	if cell_info.cell_style == CELL_STYLES.SIN \
			or cell_info.cell_style == CELL_STYLES.SAW:
		var minimun = 0
		var maximun = SPD.LEVEL_HEIGHT
		var inner_cell_point = fmod(cell_x, SPD.LEVEL_WIDTH)
		var inner_cell_point_factor = inner_cell_point / SPD.LEVEL_WIDTH
		var sine_in_cell_x = sin(2 * PI * inner_cell_point_factor)
		var sine_in_safezone = (sine_in_cell_x + 1) / 2 * SPD.LEVEL_HEIGHT
		if sine_in_safezone - current_tunnel_width < 0:
			minimun = sine_in_safezone + current_tunnel_width
			maximun = SPD.LEVEL_HEIGHT
		elif sine_in_safezone + current_tunnel_width > SPD.LEVEL_HEIGHT:
			minimun = 0
			maximun = sine_in_safezone - current_tunnel_width
			return rnd.randi_range(minimun, maximun)
		else:
			if rnd.randi_range(0, 1) == 0:
				minimun = 0
				maximun = sine_in_safezone - current_tunnel_width
			else:
				minimun = sine_in_safezone + current_tunnel_width
				maximun = SPD.LEVEL_HEIGHT
		return rnd.randi_range(minimun, maximun)

	# TODO: Implement SAW

	else:
		return rnd.randi_range(0, SPD.LEVEL_HEIGHT)

func _spawn_random_entity(cell_info, cell_number):
	var adjusted_variety = {}
	for entity_info_key in SPD.SPACE_ENTITIES_INFO.keys():
		adjusted_variety[entity_info_key] = \
			SPD.SPACE_ENTITIES_INFO[entity_info_key].rarity \
			* variety_reduction_factor \
			/ current_variety
	var pool = []
	var roll = rnd.randf()
	for entity in adjusted_variety.keys():
		if adjusted_variety[entity] < roll:
			pool.push_back(entity)
	var selected_entity = _select_random_entity()

	var new_entity = \
		SPD.SPACE_ENTITIES_INFO[selected_entity].scene.instance()
	var entity_x = \
		rnd.randi_range(0, SPD.LEVEL_WIDTH) + cell_number * SPD.LEVEL_WIDTH
	new_entity.set_global_position(Vector2(
		entity_x,
		_get_valid_y_coord(cell_info, entity_x)
	))
	call_deferred("add_child", new_entity)

func _new_cell(cell_number):

	var safezone_style_max = CELL_STYLES.SAW
	if goodluck:
		safezone_style_max = CELL_STYLES.GOODLUCK
	var new_safezone_style = \
		rnd.randi_range(CELL_STYLES.TUNNEL, safezone_style_max)

	var new_safezone_height = CELL_HEIGHTS.MIDDLE
	if goodluck:
		new_safezone_height = \
			rnd.randi_range(CELL_HEIGHTS.TOP, CELL_HEIGHTS.BOTTOM)

	var new_cell = Cell.new(new_safezone_style, new_safezone_height)

	# Cell behind coord 0 always empty
	if cell_number == -1:
		pass

	# First cell always have one planet
	elif cell_number == 0:
		var new_entity = SPD.SPACE_ENTITIES_INFO[0].scene.instance()
		new_entity.set_global_position(Vector2(SPD.LEVEL_WIDTH * 0.75, 520))
		call_deferred("add_child", new_entity)

	# For other cells use rnd
	else:
		for _number in range(floor(current_density)):
			_spawn_random_entity(new_cell, cell_number)

	return new_cell

func _clear_cell(cell):
	for entity in cell.entities:
		entity.free()

func _init_cells():
	for cell in cells:
		_clear_cell(cell)
	cells = []
	cells.push_back(_new_cell(current_cell - 2))
	cells.push_back(_new_cell(current_cell - 1))
	cells.push_back(_new_cell(current_cell))
	cells.push_back(_new_cell(current_cell + 1))
	cells.push_back(_new_cell(current_cell + 2))

func _ready():
	_update_locals()
	_init_cells()
	set_process(true)

func _shift_cells(backwards=false):
	if not backwards:
		_clear_cell(cells[0])
		cells = [cells[1], cells[2], cells[3], cells[4]]
		cells.push_back(_new_cell(current_cell + 2))
	else:
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
