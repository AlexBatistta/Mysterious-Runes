tool
extends Control

func _ready():
	Global.change_level(0)
	$ParallaxBackground.set_color()
	$Fade/AnimationPlayer.play("FadeIn")
	$PlayButton.visible = false

func _on_PlayButton_pressed():
	Global.change_level(1)
	$Fade/AnimationPlayer.play("FadeOut")
	$PlayButton.visible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		$PlayButton.visible = true
	if anim_name == "FadeOut":
		Global.change_scene("Game")


"""func _on_LinkButton_pressed():
	OS.shell_open("https://twitter.com/MaioryGames")"""
