tool
extends TileMap

enum ColorLevel {ORANGE, PURPLE, VIOLET, LIGHT_GREEN, GREEN}

export (ColorLevel) var color = ColorLevel.ORANGE setget change_color

var name_tileset = "res://Game/Tileset/TileSet-1.tres"

func change_color(_color):
	color = _color
	name_tileset = "res://Game/Tileset/TileSet-" + str(color) + ".tres"
	tile_set = load(name_tileset)
