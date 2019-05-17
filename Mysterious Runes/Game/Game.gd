extends Node2D

enum ColorLevel {ORANGE, PURPLE, VIOLET, LIGHT_GREEN, GREEN}

export (ColorLevel) var color = ColorLevel.ORANGE setget change_color
export (int, 1, 5) var current_level = 1 setget change_level

func change_color(_color):
	color = _color

func change_level(_level):
	current_level = _level

func setup_level():
	$CanvasLayer/FadeOut/AnimationPlayer.play("Fade")
	$Levels.setup(current_level, color, $Player)
	$Player/Camera2D.limit_right = $Levels.get_limits().x
	$Player/Camera2D.limit_bottom = $Levels.get_limits().y

func _ready():
	setup_level()
