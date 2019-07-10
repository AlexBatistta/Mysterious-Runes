extends Control

var buttons = [
	"VBoxContainer/HBoxContainer/TwitterButton"
]

func _on_TwitterButton_pressed():
	OS.shell_open("https://twitter.com/Gamelex_")

func _on_CreditsMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
