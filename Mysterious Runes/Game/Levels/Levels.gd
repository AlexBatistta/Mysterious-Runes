tool
extends Node2D

export (int, 1, 5) var level = 1 setget load_level

var newLevel = null

func load_level(_level):
	level = _level
	Global.change_level(level)
	change_level()

func change_level():
	if newLevel != null:
		newLevel.queue_free()
	
	var levelScene = load("res://Game/Levels/Level" + str(level) + ".tscn")
	newLevel = levelScene.instance()
	newLevel.visible = true
	add_child(newLevel)
	
	$ParallaxBackground.scroll_limit_end = get_limits()
	
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
	#$Player.levelKey = false

func set_color():
	$TileMapColor.clear()
	
	var tilemap = newLevel.get_used_cells()
	for tile in tilemap:
		var id = newLevel.get_cell(tile.x,tile.y)
		if id < 19:
			$TileMapColor.set_cell(tile.x, tile.y, id)
	
	$TileMapColor.modulate = Global.color()

func spawn_player():
	$Player.visible = true
	$Player/Sprite/AnimationPlayer.play("Spawn")

func get_limits():
	var used = newLevel.get_used_rect()
	var sizeTile = newLevel.cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)

func _ready():
	if Engine.is_editor_hint():
		load_level(1)
	else:
		load_level(Global.current_level)
		$Portal.connect("teleport", self, "spawn_player")
		$Portal2.connect("teleport", Global, "pass_level")

func _process(delta):
	if $Player.visible:
		$Camera2D.position = $Player.position
	
	if Input.is_action_just_pressed("ui_cancel"):
		Global.change_scene("Menu")
		Global.change_level(0)