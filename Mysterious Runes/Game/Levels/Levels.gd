tool
extends Node2D

export (int, 1, 5) var level = 1 setget change_level
var current_level
var player

func change_level(_level):
	level = _level
	current_level = "Level" + str(_level)
	if Engine.is_editor_hint():
		set_color(Color.white)
		var levels = get_children()
		for level in levels:
			if level.name != "TileMapColor":
				level.visible = false
			if level.name == current_level:
				level.visible = true

func set_color(_color):
	$TileMapColor.clear()
	
	var tilemap = get_node(current_level).get_used_cells()
	for tile in tilemap:
		var id = get_node(current_level).get_cell(tile.x,tile.y)
		if id < 19:
			$TileMapColor.set_cell(tile.x, tile.y, id)
	
	$TileMapColor.modulate = _color
	

func setup(_level, _color, _player):
	current_level = "Level" + str(_level)
	
	player = _player
	spawn_characters()
	
	set_color(_color)
	
	var levels = get_children()
	for level in levels:
		if level.name != current_level && level.name != "TileMapColor":
			level.queue_free()

func spawn_characters():
	var posPlayer = get_node(current_level).get_used_cells_by_id(23)
	if !posPlayer.empty():
		posPlayer = posPlayer[0]
		player.set_position(get_node(current_level).map_to_world(posPlayer))
		get_node(current_level).set_cell(posPlayer.x, posPlayer.y, -1)

func get_limits():
	var used = get_node(current_level).get_used_rect()
	var sizeTile = get_node(current_level).cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)
	