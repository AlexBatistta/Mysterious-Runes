extends Control

func _ready():
	$FadeOut/AnimationPlayer.play("Fade")

func _on_PlayButton_pressed():
	Global.change_level(1)
	Global.change_scene("Game")
