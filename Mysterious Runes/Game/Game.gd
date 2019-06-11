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
	
	$ParallaxBackground.scroll_limit_end = $Levels.get_limits()
	$ParallaxBackground.set_color($Levels._color())

func _ready():
	setup_level()

func _process(delta):
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("ui_accept"):
		#Engine.time_scale = 0.05
			_pass_level()

func _pass_level():
	if current_level < 5:
		current_level += 1;
		setup_level()