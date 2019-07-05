extends Control

func _ready():
	set_process_input(true)

func set_LifeBar(_maxValue):
	$GuiPlayer/LifeBar.max_value = _maxValue
	$GuiPlayer/LifeBar.value = _maxValue

func change_LifeBar(_life):
	$GuiPlayer/LifeBar.value = _life
	$GuiPlayer/Particles2D.emitting = true

"""func change_PowerBar():
	var value = Player.get_node("Power/PowerTimer").wait_time
	if value == 0:
		$PowerBar.max_value = 1
	else:
		$PowerBar.max_value = value

func _process(delta):
	if $PowerBar.max_value != 1:
		$PowerBar.value = Player.get_node("Power/PowerTimer").time_left
	else:
		$PowerBar.value = $PowerBar.max_value"""

func _on_PauseButton_pressed():
	Global.change_menu("MenuPause")

func _input(event):
	if event.is_action_pressed("ui_pause"):
		_on_PauseButton_pressed()
	
	if event.is_action_pressed("ui_cancel"):
		Global.change_level(0)
		Global.change_menu("MainMenu")
		Global.change_scene("Menu")
	
	if event.is_action_pressed("ui_accept"):
		$MenuLayer/PowerMenu.popup_centered_ratio(0.5)

func _on_Gui_visibility_changed():
	if visible:
		set_process_input(true)
	else:
		set_process_input(false)
