extends Control

var buttons = [
	"VBoxContainer/TwitterButton"
]

func _on_TwitterButton_pressed():
	OS.shell_open("https://twitter.com/MaioryGames")

func _on_CreditsMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
