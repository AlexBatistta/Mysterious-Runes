extends Control

#Script para el menú de créditos

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"VBoxContainer/HBoxContainer/TwitterButton"
]

#Acción del botón Twitter, abre en el explorador el twitter del desarrollador
func _on_TwitterButton_pressed():
	OS.shell_open("https://twitter.com/Gamelex_")

#Cambio en la visibilidad del nodo, visibiliza la lista de botones
func _on_CreditsMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
