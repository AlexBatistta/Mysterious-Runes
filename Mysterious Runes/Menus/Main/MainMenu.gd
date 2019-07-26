extends Control

#Script para el menú principal

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"VBoxContainer/VBoxContainer/CenterContainer/PlayButton",
	"VBoxContainer/VBoxContainer/HBoxContainer/LevelsButton",
	"VBoxContainer/VBoxContainer/HBoxContainer/HelpButton"
]

#Acción del botón Play, inicia el juego desde el primer nivel
func _on_PlayButton_pressed():
	Global.change_level(1)
	Global.change_menu("Game")

#Acción del botón Help, cambia al menú de ayuda
func _on_HelpButton_pressed():
	Global.change_menu("HelpMenu")

#Acción del botón Levels, cambia al menú de selección de nivel
func _on_LevelsButton_pressed():
	Global.change_menu("LevelsMenu")

#Cambio en la visibilidad del nodo, visibiliza la lista de botones
func _on_MainMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible