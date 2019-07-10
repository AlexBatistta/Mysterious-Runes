extends Control

func _ready():
	if Global.music: $MusicMenus.play()
	Global.change_level(0)
	$ParallaxBackground.set_color()
	_hide_nodes()
	$KeyboardController._get_buttons()
	Global.connect("transition", self, "_transition")
	$Fade/AnimationPlayer.play("FadeIn")

func _transition():
	$Fade/AnimationPlayer.play("FadeOut")
	_hide_nodes()

func _hide_nodes():
	var menus = $ListMenus.get_children()
	for menu in menus:
		menu.visible = false
	$BasicMenu.visible = false

func _draw_nodes():
	$ListMenus.get_node(Global.current_menu).visible = true
	$BasicMenu.visible = true
	$KeyboardController._get_buttons()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		_draw_nodes()
	if anim_name == "FadeOut":
		if Global.current_menu == "Game":
			Global.change_scene("Game")
		else:
			$Fade/AnimationPlayer.play("FadeIn")
