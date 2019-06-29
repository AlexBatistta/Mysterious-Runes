extends Control

func _on_PlayButton_pressed():
	Global.change_level(1)
	Global.change_menu("Game")

func _on_HelpButton_pressed():
	Global.change_menu("HelpMenu")
	print("Menu Help")

func _on_LevelsButton_pressed():
	Global.change_menu("LevelsMenu")
	print("Menu Levels")
