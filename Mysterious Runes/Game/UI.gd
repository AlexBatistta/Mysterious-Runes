extends Control

#Script para el control de la interfaz de usuario dentro del juego

#Contenedor de los botones del menú para el manejo por teclado
var buttons = []

func _ready():
	var player = get_parent().get_parent().get_node("Levels/Player")
	
	#Conecta las señales
	$Gui/RunesMenu.connect("rune", player, "rune")
	$KeyboardController.connect("pause", $MenuInGame, "_on_PlayButton_pressed")
	$Gui.set_LifeBar(player.maxLife)
	
	#Limpia la lista
	if !buttons.empty():
		buttons.clear()
	
	#Obtiene los botones
	for button in $Gui.buttons:
		buttons.push_back("Gui/" + button)
	$KeyboardController._get_buttons()
	$KeyboardController.gui = true

#Cambio en la visibilidad del nodo, actualiza la lista de botones activos
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