extends Control

var buttons = [
	"CreditsButton",
	"BackButton",
	"SoundsButtons/MusicButton",
	"SoundsButtons/SoundButton"
]

func _back_visible(_visibility):
	$BackButton.visible = _visibility
	$CreditsButton.visible = !_visibility

func _on_CreditsButton_pressed():
	Global.change_menu("CreditsMenu")
	if Global.current_state == "Game":
		Global.change_scene("Menu")
		get_tree().paused = false

func _on_BackButton_pressed():
	if Global.current_menu == "Game":
		Global.change_scene("Menu")
		get_tree().paused = false
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

func _on_BasicMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
	
	if visible:
		if Global.current_menu == "MainMenu":
			_back_visible(false)
		else:
			_back_visible(true)
		
		if Global.current_state == "Game":
			_back_visible(false)
