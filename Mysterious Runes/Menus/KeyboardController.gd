extends Control

signal pause

var buttons = []
var button_active = 0
var mouse = false
var button_sound = null

func _get_buttons():
	if buttons != null:
		buttons.clear()
	
	if Global.current_state == "Menus":
		var node = get_parent().get_node("ListMenus/" + Global.current_menu)
		for button in node.buttons:
			buttons.push_back(node.get_node(button))
		button_active = 0
	else:
		for button in get_parent().buttons:
			buttons.push_back(get_parent().get_node(button))
		button_active = 1
	
	if get_parent().has_node("BasicMenu"):
		var node2 = get_parent().get_node("BasicMenu")
		for button in node2.buttons:
			if node2.get_node(button).visible:
				buttons.push_back(node2.get_node(button))
	
	_create_sound()

func _create_sound():
	button_sound = AudioStreamPlayer.new()
	button_sound.stream = load("res://Sound/Button.ogg")
	button_sound.bus = AudioServer.get_bus_name(1)
	add_child(button_sound)

func _process(delta):
	if get_parent().visible && !buttons.empty():
		if mouse:
			buttons[button_active].release_focus()
		else:
			buttons[button_active].grab_focus()

func _input(event):
	if get_parent().visible:
		if event.is_action_released("move_up") || event.is_action_released("move_left"):
			button_active -= 1
		if event.is_action_released("move_down") || event.is_action_released("move_right"):
			button_active += 1
		
		if event.is_action_pressed("ui_cancel"):
			_sound()
			if Global.current_state == "Menus":
				if Global.current_menu != "MainMenu":
					Global.change_menu("MainMenu")
				else:
					get_tree().quit()
			else:
				if Global.current_menu == "MenuPause":
					emit_signal("pause")
		
		if event.is_action_pressed("ui_pause"):
			_sound()
			emit_signal("pause")
		
		if event is InputEventMouseMotion:
			mouse = true
		
		if event is InputEventKey:
			if !event.pressed:
				if mouse:
					if Global.current_state == "Menus": button_active = 0
					else: button_active = 1
				mouse = false
		
		if event is InputEventMouseButton && event.is_pressed() || event.is_action_pressed("ui_accept"):
			for button in buttons:
				if button.is_hovered() && !button.disabled: 
					_sound()
		
		if button_active < 0:
			button_active = buttons.size() - 1
		if button_active > buttons.size() - 1:
			button_active = 0

func _sound():
	if !button_sound.playing:
		button_sound.play()