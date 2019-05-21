tool
extends Node2D


export (int, 1, 5) var current_level = 1 setget change_level

func change_level(_level):
	current_level = _level
	if Engine.is_editor_hint():
		$Levels.change_level(_level)
		$Levels.set_color(_color())

func setup_level():
	if !Engine.is_editor_hint():
		$CanvasLayer/FadeOut/AnimationPlayer.play("Fade")
		$Levels.setup(current_level, _color(), $Player)
		$Player/Camera2D.limit_right = $Levels.get_limits().x
		$Player/Camera2D.limit_bottom = $Levels.get_limits().y

func _ready():
	setup_level()

func _color():
	match current_level:
		1:	return Color.red
		2:	return Color.blue
		3:	return Color.green
		4:	return Color.yellow
		5:	return Color.purple