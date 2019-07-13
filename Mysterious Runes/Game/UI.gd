extends Control

var buttons = []

func _ready():
	var player = get_parent().get_parent().get_node("Levels/Player")
	
	$Gui/RunesMenu.connect("rune", player, "rune")
	$KeyboardController.connect("pause", $MenuInGame, "_on_PlayButton_pressed")
	$Gui.set_LifeBar(player.maxLife)
	
	for button in $Gui.buttons:
		buttons.push_back("Gui/" + button)
	$KeyboardController._get_buttons()

func _on_MenuInGame_visibility_changed():
	if $MenuInGame.visible:
		for button in $MenuInGame.buttons:
			buttons.push_back("MenuInGame/" + button)
		
	else:
		for button in $Gui.buttons:
			buttons.push_back("Gui/" + button)
	$KeyboardController._get_buttons()