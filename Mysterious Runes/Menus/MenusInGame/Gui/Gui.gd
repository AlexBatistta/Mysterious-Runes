extends Control

#Script que controla la GUI del juego

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"PauseButton",
	"GuiPlayer/RuneMenuButton"
]
var timeRunes = Global.TIME_POWER + 5

func _ready():
	set_process_input(true)
	
	$GuiPlayer/PowerBar.max_value = Global.TIME_POWER
	$GuiPlayer/SpecialBar.max_value = timeRunes
	$GuiPlayer/RuneMenuButton.disabled = true
	
	#Si ya desbloqueó un nivel, se habilita el contador para el menú especial
	if Global.levelsUnlock > 1:
		$TimerRune.start(timeRunes)

func _process(delta):
	#Modifica el valor de la barra especial (indica cuándo se habilita el menú especial)
	if !$TimerRune.is_stopped(): 
		$GuiPlayer/SpecialBar.value = $TimerRune.time_left
	else:
		$GuiPlayer/SpecialBar.value = timeRunes
	
	#"Rellena" la barra de poder sino se utiliza
	if $TimerPower.is_stopped():
		$GuiPlayer/PowerBar.value = Global.TIME_POWER
	
	#Si el poder esta activo, se modifica la barra y se inicia el contador del poder,
	#sino se inicia el contador especial
	if Global.rune_active:
		if $TimerPower.is_stopped(): $TimerPower.start(Global.TIME_POWER)
		$GuiPlayer/PowerBar.value = $TimerPower.time_left
		$GuiPlayer/SpecialBar.value = timeRunes
		$TimerRune.stop()
		if !$GuiPlayer/RuneMenuButton.disabled:
			_disable_RuneMenu()
	elif $TimerRune.is_stopped() && $GuiPlayer/RuneMenuButton.disabled:
		if Global.levelsUnlock > 1:
			$TimerRune.start(timeRunes)
		elif Global.levelKey:
			$TimerRune.start(timeRunes)

#Personaliza la barra de vida
func set_LifeBar(_maxValue):
	$GuiPlayer/LifeBar.max_value = _maxValue
	$GuiPlayer/LifeBar.value = _maxValue

#Modifica la barra de vida
func change_LifeBar(_life):
	$GuiPlayer/LifeBar.value = _life

#Acción del boton Pause, cambia al menú de pausa 
func _on_PauseButton_pressed():
	Global.change_menu("MenuPause")

#Habilita el menú especial
func _enable_RuneMenu():
	#Cambia la textura 
	var path = "res://Menus/MenusInGame/Gui/LifeBar-02.png"
	$GuiPlayer.texture = load(path)
	
	#Habilita el botón
	$GuiPlayer/RuneMenuButton.disabled = false
	
	#Emite partículas
	$GuiPlayer/ParticlesRune.emitting = true
	
	#Efecto de sonido
	$GuiAudio.stream = load("res://Sound/Rune.ogg")
	$GuiAudio.play()

#Deshabilita el menú especial
func _disable_RuneMenu():
	#Cambia la textura 
	var path = "res://Menus/MenusInGame/Gui/LifeBar-01.png"
	$GuiPlayer.texture = load(path)
	
	#Deshabilita el botón
	$GuiPlayer/RuneMenuButton.disabled = true
	
	#Para la emisión de partículas
	$GuiPlayer/ParticlesRune.emitting = false

#Input del teclado
func _input(event):
	if event.is_action_pressed("ui_pause"):
		_on_PauseButton_pressed()
	
	if event.is_action_pressed("ui_cancel"):
		Global.change_menu("MainMenu")
		Global.change_scene("Menu")
	
	if !$GuiPlayer/RuneMenuButton.disabled:
		if event.is_action_pressed("runes"):
			_on_RuneMenuButton_pressed()

#Cambio en la visibilidad del nodo, habilita o deshabilita el input
func _on_Gui_visibility_changed():
	if visible:
		set_process_input(true)
	else:
		set_process_input(false)

#Cuando finaliza el contador, habilita el menú especial
func _on_TimerRune_timeout():
	_enable_RuneMenu()

#Acción del botón RuneMenu, deshabilita el input y crea el menú
func _on_RuneMenuButton_pressed():
	get_parent().set_process_input(false)
	set_process_input(false)
	$RunesMenu.popup_centered_ratio(0.5)

#Cuando se cierra el menu, se deshabilita el botón y se habilita el input
func _on_RunesMenu_popup_hide():
	get_parent().set_process_input(true)
	set_process_input(true)
	_disable_RuneMenu()

#Cuando finaliza el contador, deshabilita el poder
func _on_TimerPower_timeout():
	Global.rune_active = false
