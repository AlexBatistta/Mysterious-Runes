tool
extends Node2D

enum ColorLevel {ORANGE, PURPLE, VIOLET, LIGHT_GREEN, GREEN}

export (ColorLevel) var color = ColorLevel.ORANGE setget change_color

var name_texture = "res://Game/Tileset/Tileset-0.png"

func change_color(_color):
	color = _color
	name_texture = "res://Game/Tileset/Tileset-" + str(color) + ".png"
	var sprites = get_children()
	for sprite in sprites:
		sprite.texture = load(name_texture)


	
	
