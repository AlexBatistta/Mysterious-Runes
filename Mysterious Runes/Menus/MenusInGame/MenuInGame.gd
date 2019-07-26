extends Control

#Script para el control de los menús dentro del juego

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"HBoxContainer/HomeButton",
	"HBoxContainer/PlayButton",
	"HBoxContainer/LevelsButton"
]
var menu = ""

#Modifica la escena según el menú
func set_menu(_menu):
	menu = _menu
	
	$HBoxContainer/PlayButton/Icon.texture.region = Rect2(0, 0, 100, 100)
	$HBoxContainer/LevelsButton/Icon.texture.region = Rect2(100, 0, 100, 100)
	$GameComplete.text = "Level " + str(Global.current_level)
	
	match menu:
		"MenuPause":
			$TitleMenu.texture.region = Rect2(0, 0, 575, 150)
			$HBoxContainer/LevelsButton/Icon.texture.region = Rect2(100, 100, 100, 100)
		"MenuWin":
			$TitleMenu.texture.region = Rect2(0, 150, 575, 150)
			if Global.current_level == Global.MAX_LEVELS:
				$GameComplete.text = "Game Complete!!!"
		"MenuLose":
			$TitleMenu.texture.region = Rect2(0, 300, 575, 150)
			$HBoxContainer/PlayButton/Icon.texture.region = Rect2(100, 100, 100, 100)

#Acción del botón Play
func _on_PlayButton_pressed():
	if Global.current_menu == "Game":
		Global.change_menu("MenuPause")
	else:
		#Si completó los niveles vuelve al menú principal, sino pasa de nivel
		if menu == "MenuWin":
			if Global.current_level == Global.MAX_LEVELS:
				Global.change_menu("MainMenu")
				Global.change_scene("Menu")
				return
			else:
				Global.pass_level()
		
		#Vuelve a recargar el nivel
		if menu == "MenuLose":
			Global.try_again()
		
		#Desconecta la señal si cambia de escena
		if menu != "MenuPause":
			Global.disconnect("transition", Global.current_scene, "_transition")
		
		Global.change_menu("Game")

#Acción del botón Home, vuelve al menú principal
func _on_HomeButton_pressed():
	Global.change_menu("MainMenu")
	Global.change_scene("Menu")

#Acción del botón Levels
func _on_LevelsButton_pressed():
	if "MenuPause":
		#Vuelve a cargar el nivel
		Global.try_again()
		Global.disconnect("transition", Global.current_scene, "_transition")
		Global.change_menu("Game")
	else:
		#Carga el menú de selección de niveles
		Global.change_menu("LevelsMenu")
		Global.change_scene("Menu")
