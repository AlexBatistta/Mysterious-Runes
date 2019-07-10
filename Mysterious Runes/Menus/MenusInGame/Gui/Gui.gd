extends Control

var timeRunes = Global.timePower * 5

func _ready():
	set_process_input(true)
	$GuiPlayer/PowerBar.max_value = Global.timePower
	$GuiPlayer/SpecialBar.max_value = timeRunes
	$TimerRune.start(timeRunes)
	$GuiPlayer/RuneMenuButton.disabled = true

func _process(delta):
	if Global.rune_active:
		if $TimerPower.is_stopped(): $TimerPower.start(Global.timePower)
		$GuiPlayer/PowerBar.value = $TimerPower.time_left
		$TimerRune.stop()
		$GuiPlayer/SpecialBar.value = timeRunes
		if !$GuiPlayer/RuneMenuButton.disabled: _disable_RuneMenu()
	else:
		if $TimerRune.is_stopped(): $TimerRune.start(timeRunes)
		else: $GuiPlayer/SpecialBar.value = $TimerRune.time_left

func set_LifeBar(_maxValue):
	$GuiPlayer/LifeBar.max_value = _maxValue
	$GuiPlayer/LifeBar.value = _maxValue

func change_LifeBar(_life):
	$GuiPlayer/LifeBar.value = _life

func _on_PauseButton_pressed():
	Global.change_menu("MenuPause")

func _enable_RuneMenu():
	var path = "res://Menus/MenusInGame/Gui/LifeBar-02.png"
	$GuiPlayer.texture = load(path)
	$GuiPlayer/RuneMenuButton.disabled = false
	$GuiPlayer/ParticlesRune.emitting = true
	$GuiAudio.stream = load("res://Sound/Rune.ogg")
	$GuiAudio.play()

func _disable_RuneMenu():
	var path = "res://Menus/MenusInGame/Gui/LifeBar-01.png"
	$GuiPlayer.texture = load(path)
	$GuiPlayer/RuneMenuButton.disabled = true
	$GuiPlayer/ParticlesRune.emitting = false

func _input(event):
	if event.is_action_pressed("ui_pause"):
		_on_PauseButton_pressed()
	
	if event.is_action_pressed("ui_cancel"):
		Global.change_menu("MainMenu")
		Global.change_scene("Menu")
	
	if !$GuiPlayer/RuneMenuButton.disabled:
		if event.is_action_pressed("runes"):
			_on_RuneMenuButton_pressed()

func _on_Gui_visibility_changed():
	if visible:
		set_process_input(true)
	else:
		set_process_input(false)

func _on_TimerRune_timeout():
	_enable_RuneMenu()

func _on_RuneMenuButton_pressed():
	get_parent().set_process_input(false)
	set_process_input(false)
	$RunesMenu.popup_centered_ratio(0.5)

func _on_RunesMenu_popup_hide():
	get_parent().set_process_input(true)
	set_process_input(true)
