tool
extends Node2D

export (int, 1, 5) var level = 1 setget load_level

var newLevel = null

func load_level(_level):
	level = _level
	Global.current_level = level
	change_level()

func change_level():
	if newLevel != null:
		newLevel.queue_free()
	
	var levelScene = load("res://Game/Levels/Level" + str(level) + ".tscn")
	newLevel = levelScene.instance()
	newLevel.visible = true
	add_child(newLevel)
	
	$ParallaxBackground.scroll_limit_end = get_limits()
	$ParallaxBackground.set_color(_color())
	
	set_color()
	
	var portals = newLevel.get_used_cells_by_id(19)
	for portal in portals:
		newLevel.set_cell(portal.x, portal.y, -1)
	
	$Portal.position = newLevel.map_to_world(portals[0]) + Vector2(48, 96)
	$Portal2.position = newLevel.map_to_world(portals[1]) + Vector2(48, 96)
	$Portal.reset()
	
	$Camera2D.position = $Portal.position
	$Camera2D.limit_right = get_limits().x
	$Camera2D.limit_bottom = get_limits().y
	
	$Player.position = $Portal.position
	$Player.visible = false
	$Player.levelKey = false

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
			if child.is_in_group("Spawn") || child.is_in_group("Platform") || child.is_in_group("Stalactite"):
				child.change_color(_color())

func spawn_player():
	$Player.visible = true
	$Player/Sprite/AnimationPlayer.play("Spawn")

func get_limits():
	var used = newLevel.get_used_rect()
	var sizeTile = newLevel.cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)

func _color():
	match Global.current_level:
		1:	return Color.red
		2:	return Color.blue
		3:	return Color.green
		4:	return Color.yellow
		5:	return Color.purple

func _ready():
	load_level(Global.current_level)
	if !Engine.is_editor_hint():
		$Portal.connect("teleport", self, "spawn_player")
		$Portal2.connect("teleport", Global, "pass_level")

func _process(delta):
	if $Player.visible:
		$Camera2D.position = $Player.position
	
	if Input.is_action_just_pressed("ui_cancel"):
		Global.change_scene("Menu")