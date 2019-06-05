tool
extends Node2D

export (int, 1, 5) var level = 1 setget change_level
var player
var newLevel = load("res://Game/Levels/Level1.tscn").instance()

func change_level(_level):
	level = _level
	
	newLevel.queue_free()
	var levelScene = load("res://Game/Levels/Level" + str(_level) + ".tscn")
	newLevel = levelScene.instance()
	newLevel.visible = true
	add_child(newLevel)
	
	set_color()

func set_color():
	$TileMapColor.clear()
	
	var tilemap = newLevel.get_used_cells()
	for tile in tilemap:
		var id = newLevel.get_cell(tile.x,tile.y)
		if id < 19:
			$TileMapColor.set_cell(tile.x, tile.y, id)
	
	$TileMapColor.modulate = _color()
	
	var children = newLevel.get_children()
	if !children.empty():
		for child in children:
			if child.is_in_group("Spawn") || child.is_in_group("Platform"):
				child.change_color(_color())

func position_player():
	var posPlayer = newLevel.get_used_cells_by_id(19)
	if !posPlayer.empty():
		posPlayer = posPlayer[0]
		newLevel.set_cell(posPlayer.x, posPlayer.y, -1)
		return newLevel.map_to_world(posPlayer)
	else:
		return Vector2(0, 0)

func get_limits():
	var used = newLevel.get_used_rect()
	var sizeTile = newLevel.cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)

func _color():
	match level:
		1:	return Color.red
		2:	return Color.blue
		3:	return Color.green
		4:	return Color.yellow
		5:	return Color.purple

func _ready():
	change_level(level)