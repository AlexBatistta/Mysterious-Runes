extends Control

var menu = ""
var buttons = [
	"HBoxContainer/HomeButton",
	"HBoxContainer/PlayButton",
	"HBoxContainer/LevelsButton"
]

func set_menu(_menu):
	menu = _menu
	
	$HBoxContainer/PlayButton/Icon.texture.region = Rect2(0, 0, 100, 100)
	$HBoxContainer/LevelsButton/Icon.texture.region = Rect2(100, 0, 100, 100)
	$GameComplete.text = "Level " + str(Global.current_level)
	
	match menu:
		"MenuPause":
			$TitleMenu.texture.region = Rect2(0, 0, 575, 150)
			$HBoxContainer/LevelsButton/Icon.texture.region = Rect2(100, 100, 100, 100)
		"MenuWin":
			$TitleMenu.texture.region = Rect2(0, 150, 575, 150)
			if Global.current_level == Global.maxLevels:
				$GameComplete.text = "Game Complete!!!"
		"MenuLose":
			$TitleMenu.texture.region = Rect2(0, 300, 575, 150)
			$HBoxContainer/PlayButton/Icon.texture.region = Rect2(100, 100, 100, 100)

func _on_PlayButton_pressed():
	if Global.current_menu == "Game":
		Global.change_menu("MenuPause")
	else:
		if menu == "MenuWin":
			if Global.current_level == Global.maxLevels:
				Global.change_menu("MainMenu")
				Global.change_scene("Menu")
				return
			else:
				Global.pass_level()
		if menu == "MenuLose":
			Global.try_again()
		if menu != "MenuPause":
			Global.disconnect("transition", Global.current_scene, "_transition")
		Global.change_menu("Game")

func _on_HomeButton_pressed():
	Global.change_menu("MainMenu")
	Global.change_scene("Menu")

func _on_LevelsButton_pressed():
	if "MenuPause":
		Global.try_again()
		Global.disconnect("transition", Global.current_scene, "_transition")
		Global.change_menu("Game")
	else:
		Global.change_menu("LevelsMenu")
		Global.change_scene("Menu")
