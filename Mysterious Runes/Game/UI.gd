extends Control

func _ready():
	var player = get_parent().get_parent().get_node("Levels/Player")
	
	$Gui/RunesMenu.connect("rune", player, "rune")
	$MenuInGame/KeyboardController.connect("pause", $MenuInGame, "_on_PlayButton_pressed")
	$Gui.set_LifeBar(player.maxLife)

func _on_MenuInGame_visibility_changed():
	if $MenuInGame.visible:
		$MenuInGame/KeyboardController._get_buttons()
