tool
extends Control

func _ready():
	Global.change_level(0)
	$ParallaxBackground.set_color()
	$Fade/AnimationPlayer.play("FadeIn")
	_hide_nodes()
	Global.connect("transition", self, "_transition")

func _transition():
	$Fade/AnimationPlayer.play("FadeOut")
	_hide_nodes()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		_draw_nodes()
	if anim_name == "FadeOut":
		$Fade/AnimationPlayer.play("FadeIn")
		if Global.current_menu == "Game":
			Global.change_scene("Game")

func _on_CreditsButton_pressed():
	Global.change_menu("CreditsMenu")
	print("Credits Levels")

func _on_BackButton_pressed():
	Global.change_menu("MainMenu")

func _on_SoundButton_pressed():
	Global.set_sound()
	var normal_icon
	var hover_icon
	if Global.sound:
		normal_icon = Rect2(200, 200, 100, 100)
		hover_icon = Rect2(200, 300, 100, 100)
	else:
		normal_icon = Rect2(300, 200, 100, 100)
		hover_icon = Rect2(300, 300, 100, 100)
	$SoundsButtons/SoundButton.texture_normal.region = normal_icon
	$SoundsButtons/SoundButton.texture_hover.region = hover_icon

func _on_MusicButton_pressed():
	Global.set_music()
	var normal_icon
	var hover_icon
	if Global.music:
		normal_icon = Rect2(0, 200, 100, 100)
		hover_icon = Rect2(0, 300, 100, 100)
	else:
		normal_icon = Rect2(100, 200, 100, 100)
		hover_icon = Rect2(100, 300, 100, 100)
	$SoundsButtons/MusicButton.texture_normal.region = normal_icon
	$SoundsButtons/MusicButton.texture_hover.region = hover_icon

func _hide_nodes():
	var menus = $ListMenus.get_children()
	for menu in menus:
		menu.visible = false
	$SoundsButtons.visible = false
	$CreditsButton.visible = false
	$BackButton.visible = false

func _draw_nodes():
	$ListMenus.get_node(Global.current_menu).visible = true
	$SoundsButtons.visible = true
	if Global.current_menu == "MainMenu":
		$CreditsButton.visible = true
	else:
		$BackButton.visible = true