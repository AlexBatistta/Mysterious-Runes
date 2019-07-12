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
	$Levels.add_child(newLevel)
	
	$ParallaxBackground.scroll_limit_end = get_limits()
	
	set_color()
	
	var portals = newLevel.get_used_cells_by_id(19)
	for portal in portals:
		newLevel.set_cell(portal.x, portal.y, -1)
	
	$Levels/Portal.position = newLevel.map_to_world(portals[0]) + Vector2(48, 96)
	$Levels/Portal2.position = newLevel.map_to_world(portals[1]) + Vector2(48, 96)
	$Levels/Portal.reset()
	$Levels/Portal2.reset()
	
	$Levels/Player/Camera2D.limit_right = get_limits().x
	$Levels/Player/Camera2D.limit_bottom = get_limits().y
	
	$Levels/Player.position = $Levels/Portal.position
	$Levels/Player.visible = false
	
	Global.rune_active = false

func set_color():
	$Levels/TileMapColor.clear()
	
	var tilemap = newLevel.get_used_cells()
	for tile in tilemap:
		var id = newLevel.get_cell(tile.x,tile.y)
		if id < 19:
			$Levels/TileMapColor.set_cell(tile.x, tile.y, id)
	
	$Levels/TileMapColor.modulate = Global.color()

func get_limits():
	var used = newLevel.get_used_rect()
	var sizeTile = newLevel.cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)

func _ready():
	if Engine.is_editor_hint():
		load_level(1)
	else:
		load_level(Global.current_level)
		$Levels/Portal.connect("teleport", $Levels/Player, "_spawn")
		$Levels/Player.connect("change_life", $MenuLayer/UI/Gui, "change_LifeBar")
		Global.connect("transition", self, "_transition")
		
		if Global.music: $MusicGame.play()

func _transition():
	$MenuLayer/Fade/AnimationPlayer.play("FadeInOut")
	_hide_nodes()
	if Global.current_menu != "Game":
		$MenuLayer/UI/MenuInGame.set_menu(Global.current_menu)
		get_tree().paused = true
	else:
		get_tree().paused = false

func _hide_nodes():
	$Levels.visible = false
	$MenuLayer/UI/Gui.visible = false
	$MenuLayer/UI/MenuInGame.visible = false

func _draw_current_state():
	if Global.current_menu != "Game":
		$MenuLayer/UI/MenuInGame.visible = true
	else:
		$Levels.visible = true
		$MenuLayer/UI/Gui.visible = true