extends Control

#Script para el menú de créditos

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"Buttons/ControlsButton",
	"Buttons/RunesButton",
	"BackButton"
]

#Acción del botón Runes 
func _on_RunesButton_pressed():
	_button_pressed("RunesLabel")

#Acción del botón Controls 
func _on_ControlsButton_pressed():
	_button_pressed("ControlsLabel")

#Acción del botón Back, oculta los nodos
func _on_BackButton_pressed():
	$Buttons.visible = true
	$BackButton.visible = false
	$ControlsLabel.visible = false
	$RunesLabel.visible = false

#Visibiliza el nodo correspondiente
func _button_pressed(_name):
	$Buttons.visible = false
	$BackButton.visible = true
	get_node(_name).visible = true

#Cambio en la visibilidad del nodo, visibiliza la lista de botones
func _on_HelpMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
	$BackButton.visible = false
