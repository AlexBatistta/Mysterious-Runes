extends Control

var menu = ""
var button_active = 0
var buttons = [
	"HBoxContainer/HomeButton",
	"HBoxContainer/PlayButton",
	"HBoxContainer/LevelsButton"
]

func _ready():
	set_process_input(false)

func set_menu(_menu):
	menu = _menu
	$HBoxContainer/PlayButton/Icon.texture.region = Rect2(0, 0, 100, 100)
	match menu:
		"MenuPause":
			$TitlePause.texture.region = Rect2(0, 0, 575, 150)
		"MenuWin":
			$TitlePause.texture.region = Rect2(0, 150, 575, 150)
		"MenuLose":
			$TitlePause.texture.region = Rect2(0, 300, 575, 150)
			$HBoxContainer/PlayButton/Icon.texture.region = Rect2(100, 100, 100, 100)

func _on_PlayButton_pressed():
	Global.change_menu("Game")
	if menu == "MenuWin":
		Global.pass_level()
	if menu == "MenuLose":
		Global.try_again()

func _input(event):
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_pause"):
		_on_PlayButton_pressed()

func _on_MenuInGame_visibility_changed():
	if visible:
		$KeyboardController._get_buttons()
		set_process_input(true)
	else:
		set_process_input(false)

func _on_HomeButton_pressed():
	Global.change_menu("MainMenu")
	Global.change_scene("Menu")

func _on_LevelsButton_pressed():
	Global.change_menu("LevelsMenu")
	Global.change_scene("Menu")
