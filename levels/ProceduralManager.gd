extends Node


# This script spawns and destroys space elements as the player moves to the
# right. It expects a "Camera" sibling to determine the current level position.
# The scripts considers the level as a series of separated "cells" with the
# width of a game screen. To handle spawning and clearing, an array of 5 cells
# is kept. Each cell has a a list to hold the entities spawned inside it and
# other fields to determine the spawning algorithm. Spawning is done avoiding
# a clear strip randomly generated using an function.


# Form followed by the cleared area in the screen (space ensured empty)
enum TUNNEL_GENERATORS {
	MIDDLE = 0,   # A strip in the middle of the screen
	SIN = 1,      # A sine wave
	SAW = 2,      # A saw (back an forth diagonally from top to bottom)
	GOODLUCK = 3, # Disable the ensured space
}


class Cell:
	var tunnel_generator = 0
	var entities = []
	func _init(
		initial_tunnel_generator = TUNNEL_GENERATORS.MIDDLE
	):
		self.tunnel_generator = initial_tunnel_generator


# Store the two previous cells, the current cell and the next two cells
var cells = []


# Editor configuration with defaul values
export(float) var initial_density = 3
export(int) var density_change_distance = 1960
export(float) var density_change_ammount = 1

export(float) var initial_variety = 1
export(int) var variety_change_distance = 1960
export(float) var variety_change_ammount = 0.5
export(float) var variety_reduction_factor = 1

export(float) var initial_tunnel_widht = 450
export(int) var tunnel_widht_change_distance = 1960
export(float) var tunnel_widht_change_ammount = 10
export(int) var tunnel_widht_change_minimun = 150

export(bool) var goodluck_enabled = false


# Locals
onready var rnd = RandomNumberGenerator.new()
onready var root = $".."
onready var camera = $"../Camera"
onready var last_cell = floor(camera.position.x / SPD.LEVEL_WIDTH * 2)
var camera_density = initial_density
var camera_variety = initial_variety
var camera_tunnel_width = initial_tunnel_widht
var camera_cell = 0


# Update script locals
func _update_locals():
	camera_cell = floor(camera.position.x / SPD.LEVEL_WIDTH * 2)
	camera_density = initial_density + abs(
		int(camera.position.x / density_change_distance)
		* density_change_ammount
	)
	camera_variety = initial_variety + abs(
		int(camera.position.x / variety_change_distance)
		* variety_change_ammount
	)
	camera_tunnel_width = initial_tunnel_widht - abs(
		int(camera.position.x / tunnel_widht_change_distance)
		* tunnel_widht_change_ammount
	)
	camera_tunnel_width = \
		max(camera_tunnel_width, tunnel_widht_change_minimun)


func _get_valid_y_coord(cell_info, cell_x):

	if cell_info.tunnel_generator == TUNNEL_GENERATORS.MIDDLE:
		var top_minimun = 0
		var top_maximun = SPD.LEVEL_HEIGHT / 2 - camera_tunnel_width / 2
		var bottom_minimun = SPD.LEVEL_HEIGHT / 2 + camera_tunnel_width / 2
		var bottom_maximun = SPD.LEVEL_HEIGHT
		if rnd.randi_range(0, 1) == 0:
			return rnd.randi_range(top_minimun, top_maximun)
		else:
			return rnd.randi_range(bottom_minimun, bottom_maximun)

	if cell_info.tunnel_generator == TUNNEL_GENERATORS.SIN \
			or cell_info.tunnel_generator == TUNNEL_GENERATORS.SAW:
		var minimun = 0
		var maximun = SPD.LEVEL_HEIGHT
		var cell_x_as_factor = cell_x / float(SPD.LEVEL_WIDTH)
		var base_sine = sin(2 * PI * cell_x_as_factor)
		var safezone_height = (base_sine + 1) / 2 * SPD.LEVEL_HEIGHT
		if safezone_height - camera_tunnel_width < 0:
			minimun = safezone_height + camera_tunnel_width
			maximun = SPD.LEVEL_HEIGHT
		elif safezone_height + camera_tunnel_width > SPD.LEVEL_HEIGHT:
			minimun = 0
			maximun = safezone_height - camera_tunnel_width
		else:
			if rnd.randi_range(0, 1) == 0:
				minimun = 0
				maximun = safezone_height - camera_tunnel_width
			else:
				minimun = safezone_height + camera_tunnel_width
				maximun = SPD.LEVEL_HEIGHT
		return rnd.randi_range(minimun, maximun)

	# TODO: Implement SAW

	else:
		return rnd.randi_range(0, SPD.LEVEL_HEIGHT)


func _select_random_entity():
	var adjusted_variety = {}
	for entity_info_key in SPD.SPACE_ENTITIES_INFO.keys():
		adjusted_variety[entity_info_key] = \
			SPD.SPACE_ENTITIES_INFO[entity_info_key].rarity \
			* variety_reduction_factor \
			/ camera_variety
	var pool = []
	var roll = rnd.randf()
	for entity in adjusted_variety.keys():
		if adjusted_variety[entity] < roll:
			pool.push_back(entity)
	return pool[rnd.randi_range(0, len(pool)-1)]


func _init_random_entity(cell_info, cell_number):

	var selected_entity = _select_random_entity()
	var new_entity = \
		SPD.SPACE_ENTITIES_INFO[selected_entity].scene.instance()

	var entity_cell_x = rnd.randi_range(0, SPD.LEVEL_WIDTH)
	new_entity.set_global_position(Vector2(
		entity_cell_x + cell_number * SPD.LEVEL_WIDTH,
		_get_valid_y_coord(cell_info, entity_cell_x)
	))

	if selected_entity == SPD.SPACE_ENTITIES.PLANET:
		# TODO: Spawn fuel or dark energy
		pass

	if selected_entity == SPD.SPACE_ENTITIES.ASTEROID:
		if rnd.randi_range(0, 1) == 1:
			new_entity.velocity = Vector2(0, rnd.randf_range(-200, 200))

	call_deferred("add_child", new_entity)


func _spawn_random_entity(cell_info, cell_number):
	var adjusted_variety = {}
	for entity_info_key in SPD.SPACE_ENTITIES_INFO.keys():
		adjusted_variety[entity_info_key] = \
			SPD.SPACE_ENTITIES_INFO[entity_info_key].rarity \
			* variety_reduction_factor \
			/ camera_variety
	var pool = []
	var roll = rnd.randf()
	for entity in adjusted_variety.keys():
		if adjusted_variety[entity] < roll:
			pool.push_back(entity)
	_init_random_entity(cell_info, cell_number)


func _new_cell(cell_number):

	var tunnel_style_limit = TUNNEL_GENERATORS.SAW
	if goodluck_enabled:
		tunnel_style_limit = TUNNEL_GENERATORS.GOODLUCK

	var new_cell = \
		Cell.new(rnd.randi_range(TUNNEL_GENERATORS.MIDDLE, tunnel_style_limit))

	# Cell 0 always empty
	if cell_number == -1:
		pass

	# First cell always has one planet
	elif cell_number == 0:
		var new_entity = SPD.SPACE_ENTITIES_INFO[0].scene.instance()
		new_entity.set_global_position(Vector2(SPD.LEVEL_WIDTH * 0.75, 520))
		call_deferred("add_child", new_entity)

	# For other cells use rnd
	else:
		for _number in range(floor(camera_density)):
			_spawn_random_entity(new_cell, cell_number)

	return new_cell


func _clear_cell(cell):
	for entity in cell.entities:
		entity.free()


func _ready():
	rnd.randomize()
	_update_locals()
	cells.push_back(_new_cell(camera_cell - 2))
	cells.push_back(_new_cell(camera_cell - 1))
	cells.push_back(_new_cell(camera_cell    ))
	cells.push_back(_new_cell(camera_cell + 1))
	cells.push_back(_new_cell(camera_cell + 2))
	set_process(true)


func _shift_cells(forward=true):
	if forward:
		_clear_cell(cells[0])
		cells = [cells[1], cells[2], cells[3], cells[4]]
		cells.push_back(_new_cell(camera_cell + 2))
	else:
		_clear_cell(cells[4])
		cells = [cells[0], cells[1], cells[2], cells[3]]
		cells.push_front(_new_cell(camera_cell - 2))


func _process(_delta):
	_update_locals()

	# Cell shifting and generation
	while camera_cell > last_cell:
		_shift_cells()
		last_cell += 1
	while camera_cell < last_cell:
		_shift_cells(true)
		last_cell -= 1
