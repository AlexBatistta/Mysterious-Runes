extends Control

var buttons = [
	"Buttons/ControlsButton",
	"Buttons/RunesButton",
	"BackButton"
]

func _on_RunesButton_pressed():
	_button_pressed("RunesLabel")

func _on_ControlsButton_pressed():
	_button_pressed("ControlsLabel")

func _on_BackButton_pressed():
	$Buttons.visible = true
	$BackButton.visible = false
	$ControlsLabel.visible = false
	$RunesLabel.visible = false

func _button_pressed(_name):
	$Buttons.visible = false
	$BackButton.visible = true
	get_node(_name).visible = true

func _on_HelpMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
	$BackButton.visible = false
