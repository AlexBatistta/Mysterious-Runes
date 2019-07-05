extends Control

var buttons = [
	"VBoxContainer/VBoxContainer/CenterContainer/PlayButton",
	"VBoxContainer/VBoxContainer/HBoxContainer/LevelsButton",
	"VBoxContainer/VBoxContainer/HBoxContainer/HelpButton"
]

func _on_PlayButton_pressed():
	Global.change_level(1)
	Global.change_menu("Game")

func _on_HelpButton_pressed():
	Global.change_menu("HelpMenu")

func _on_LevelsButton_pressed():
	Global.change_menu("LevelsMenu")

func _on_MainMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible