tool
extends TileMap

var Geyser = load("res://Game/Geyser/Geyser.tscn")

func _ready():
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

