extends Node2D

export (PackedScene) var Portal

var current_level

func setup(_level, _color):
	current_level = "Level" + str(_level)
	
	spawn_objects()
	
	var tilemap = get_node(current_level).get_used_cells()
	for tile in tilemap:
		$TileMapColor.set_cell(tile.x, tile.y, get_node(current_level).get_cell(tile.x,tile.y))
	
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

func spawn_objects():
	var portals = get_node(current_level).get_used_cells_by_id(24)
	for portal in portals:
		var newPortal = Portal.instance()
		newPortal.set_position(get_node(current_level).map_to_world(portal))
		get_parent().add_child(newPortal)
		get_node(current_level).set_cell(portal.x, portal.y, -1)