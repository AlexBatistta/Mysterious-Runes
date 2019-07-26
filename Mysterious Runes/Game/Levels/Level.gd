tool
extends TileMap

#Script que se encarga de instanciar nodos según tiles específicos

#Escena del geiser
var Geyser = load("res://Game/Geyser/Geyser.tscn")

#Obtiene las celdas utilizadas
onready var usedTiles = get_used_cells()

#Crea los nodos y los agrega a escena
func create_nodes():
	var children = get_children()
	for child in children:
		if child.is_in_group("Geyser"):
			child.queue_free()
	
	var geyserUp = get_used_cells_by_id(13)
	for posGeyser in geyserUp:
		var geyser = Geyser.instance()
		geyser.setup(map_to_world(posGeyser), false)
		add_child(geyser)
	
	var geyserDown = get_used_cells_by_id(14)
	for posGeyser in geyserDown:
		var geyser = Geyser.instance()
		geyser.setup(map_to_world(posGeyser), true)
		add_child(geyser)

func _ready():
	create_nodes()
	set_process(true)

func _process(delta):
	if Engine.is_editor_hint():
		if usedTiles != get_used_cells():
			usedTiles = get_used_cells()
			create_nodes()
