tool
extends Node2D

#Script para el control total del juego, carga el nivel correspondiente 
#y administra los menús dentro del propio juego

#Establece el nivel (útil para la edición)
export (int, 1, 5) var level = 1 setget load_level

var newLevel = null

#Carga el nivel y actualiza el nivel en el nodo Global
func load_level(_level):
	level = _level
	Global.change_level(level)
	change_level()

#Cambia el nivel
func change_level():
	#Elimina el nivel cargado si existe
	if newLevel != null:
		newLevel.queue_free()
	
	#Instancia el nodo del nivel
	var levelScene = load("res://Game/Levels/Level" + str(level) + ".tscn")
	newLevel = levelScene.instance()
	newLevel.visible = true
	$Levels.add_child(newLevel)
	
	#Actualiza los límites del fondo según los límites del nivel
	$ParallaxBackground.scroll_limit_end = get_limits()
	
	#Crea el tilemap de color
	set_color()
	
	#Posiciona los portales según la celda asignada en el nivel
	var entry_portal = newLevel.get_used_cells_by_id(18)[0]
	var exit_portal = newLevel.get_used_cells_by_id(19)[0]
	
	newLevel.set_cell(entry_portal.x, entry_portal.y, -1)
	newLevel.set_cell(exit_portal.x, exit_portal.y, -1)
	
	$Levels/Portal.position = newLevel.map_to_world(entry_portal) + Vector2(48, 96)
	$Levels/Portal2.position = newLevel.map_to_world(exit_portal) + Vector2(48, 96)
	#Resetea las propiedades de los portales
	$Levels/Portal.reset()
	$Levels/Portal2.reset()
	
	#Actualiza los límites de la cámara según los límites del nivel
	$Levels/Player/Camera2D.limit_right = get_limits().x
	$Levels/Player/Camera2D.limit_bottom = get_limits().y
	
	#Posiciona al jugador y lo oculta
	$Levels/Player.position = $Levels/Portal.position
	$Levels/Player.visible = false
	
	Global.rune_active = false

#Crea un tilemap igual al nivel y se cambia el color según el nodo Global
func set_color():
	$Levels/TileMapColor.clear()
	
	var tilemap = newLevel.get_used_cells()
	for tile in tilemap:
		var id = newLevel.get_cell(tile.x,tile.y)
		if id < 19:
			$Levels/TileMapColor.set_cell(tile.x, tile.y, id)
	
	$Levels/TileMapColor.modulate = Global.color()

#Retorna los límites del nivel según la extensión del mapa
func get_limits():
	var used = newLevel.get_used_rect()
	var sizeTile = newLevel.cell_size.x
	return Vector2 (used.end.x * sizeTile, used.end.y * sizeTile)

func _ready():
	if Engine.is_editor_hint():
		load_level(1)
	else:
		#Cargado de nivel
		load_level(Global.current_level)
		
		#Conexión de señales
		$Levels/Portal.connect("teleport", $Levels/Player, "_spawn")
		$Levels/Player.connect("change_life", $MenuLayer/UI/Gui, "change_LifeBar")
		Global.connect("transition", self, "_transition")
		
		#Reproducción de música
		if Global.music: $MusicGame.play()

#Transición entre menú-juego
func _transition():
	#Animación Fade In-Out
	$MenuLayer/Fade/AnimationPlayer.play("FadeInOut")
	
	#Se ocultan los nodos
	_hide_nodes()
	
	#Pausa el juego y carga el menú correspondiente o
	#sigue con el juego
	if Global.current_menu != "Game":
		$MenuLayer/UI/MenuInGame.set_menu(Global.current_menu)
		get_tree().paused = true
	else:
		get_tree().paused = false

#Oculta todos los nodos mientras transiciona
func _hide_nodes():
	$Levels.visible = false
	$MenuLayer/UI/Gui.visible = false
	$MenuLayer/UI/MenuInGame.visible = false
	$MenuLayer/UI/BasicMenu.visible = false

#Visibiliza los nodos correspondientes al estado del juego
func _draw_current_state():
	if Global.current_menu != "Game":
		$MenuLayer/UI/MenuInGame.visible = true
		$MenuLayer/UI/BasicMenu.visible = true
	else:
		$Levels.visible = true
		$MenuLayer/UI/Gui.visible = true