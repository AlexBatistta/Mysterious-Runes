tool
extends Node2D

enum ColorLevel {ORANGE, PURPLE, VIOLET, LIGHT_GREEN, GREEN}
enum EnemyType {WEAK_BASIC, STRONG_BASIC, MAGIC_FLYER, WEAK_ARMORED, STRONG_ARMORED, INVOKER_BOSS}

export (ColorLevel) var color = ColorLevel.ORANGE setget change_color
export (EnemyType) var type = EnemyType.WEAK_BASIC setget change_type

var name_texture_01 = "res://Game/Enemies/SpriteBody/Enemy-01.png"
var name_texture_02 = "res://Game/Enemies/SpriteColor/Enemy-01.png"

func change_color(_color):
	color = _color
	#name_texture = "res://Game/Tileset/Tileset-" + str(color) + ".png"
	match color:
		ColorLevel.ORANGE:
			$Enemy/SpriteColor.modulate = Color("#f58238")
		ColorLevel.PURPLE:
			$Enemy/SpriteColor.modulate = Color("#d7569f")
		ColorLevel.VIOLET:
			$Enemy/SpriteColor.modulate = Color("#8969d3")
		ColorLevel.LIGHT_GREEN:
			$Enemy/SpriteColor.modulate = Color("#40bfb4")
		ColorLevel.GREEN:
			$Enemy/SpriteColor.modulate = Color("#45b757")

func change_type(_type):
	type = _type
	name_texture_01 = "res://Game/Enemies/SpriteBody/Enemy-0" + str(type + 1) + ".png"
	name_texture_02 = "res://Game/Enemies/SpriteColor/Enemy-0" + str(type + 1) + ".png"
	$Enemy/SpriteBody.texture = load(name_texture_01)
	$Enemy/SpriteColor.texture = load(name_texture_02)