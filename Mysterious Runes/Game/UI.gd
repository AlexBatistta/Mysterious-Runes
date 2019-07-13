extends Control

var buttons = []

func _ready():
	var player = get_parent().get_parent().get_node("Levels/Player")
	
	$Gui/RunesMenu.connect("rune", player, "rune")
	$KeyboardController.connect("pause", $MenuInGame, "_on_PlayButton_pressed")
	$Gui.set_LifeBar(player.maxLife)
	
	if !buttons.empty():
		buttons.clear()
	
	for button in $Gui.buttons:
		buttons.push_back("Gui/" + button)
	$KeyboardController._get_buttons()
	$KeyboardController.gui = true

func _on_MenuInGame_visibility_changed():
	if !buttons.empty():
		buttons.clear()
	
	if $MenuInGame.visible:
		for button in $MenuInGame.buttons:
			buttons.push_back("MenuInGame/" + button)
		$KeyboardController.gui = false
	else:
		for button in $Gui.buttons:
			buttons.push_back("Gui/" + button)
		$KeyboardController.gui = true
	
	$KeyboardController._get_buttons()