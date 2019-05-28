tool
extends Node2D

export (int, 1, 5) var current_level = 1 setget change_level

func change_level(_level):
	current_level = _level
	setup_level()

func setup_level():
	$CanvasLayer/FadeOut/AnimationPlayer.play("Fade")
	$Levels.change_level(current_level)
	$Player.position = $Levels.position_player()
	$Player/Camera2D.limit_right = $Levels.get_limits().x
	$Player/Camera2D.limit_bottom = $Levels.get_limits().y

func _ready():
	setup_level()

func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_accept"):
	#	_pass_level()

func _pass_level():
	if current_level < 5:
		current_level += 1;
		setup_level()