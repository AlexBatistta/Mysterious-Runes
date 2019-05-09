extends Node2D

enum ColorLevel {ORANGE, PURPLE, VIOLET, LIGHT_GREEN, GREEN}

export (ColorLevel) var color = ColorLevel.ORANGE setget change_color
export (int, 1, 5) var current_level = 1 setget change_level

func change_color(_color):
	color = _color

func change_level(_level):
	current_level = _level

func _ready():
	$Levels.setup(current_level, color)

func _process(delta):
	$Player/Camera2D.position = get_node("Player/Player").position 
	pass
