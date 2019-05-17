extends Node2D

var current_level
var player

func setup(_level, _color, _player):
	current_level = "Level" + str(_level)
	
	player = _player
	spawn_characters()
	spawn_objects()
	
	var tilemap = get_node(current_level).get_used_cells()
	for tile in tilemap:
		var id = get_node(current_level).get_cell(tile.x,tile.y)
		if id < 19:
			$TileMapColor.set_cell(tile.x, tile.y, id)
	
	match _color:
		0:
			$TileMapColor.modulate = Color.red
		1:
			$TileMapColor.modulate = Color.blue
		2:
			$TileMapColor.modulate = Color.red
		3:
			$TileMapColor.modulate = Color.blue
		4:
			$TileMapColor.modulate = Color.red
	
	var levels = get_children()
	for level in levels:
		if level.name != current_level && level.name != "TileMapColor":
			level.queue_free()

func spawn_characters():
	var posPlayer = get_node(current_level).get_used_cells_by_id(23)
	posPlayer = posPlayer[0]
	player.set_position(get_node(current_level).map_to_world(posPlayer))
	get_node(current_level).set_cell(posPlayer.x, posPlayer.y, -1)

func spawn_objects():
	pass

func get_limits():
	var used = get_node(current_level).get_used_rect()
	var sizeTile = get_node(current_level).cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)
	