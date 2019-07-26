extends Control

#Script que maneja el control por teclado de la UI

signal pause

var buttons = []
var button_active = 0
var mouse = false
var button_sound = null
var gui = false

#Obtiene la lista de botones que se encuentran visibles en escena
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

#Crea el sonido para los botones
func _create_sound():
	button_sound = AudioStreamPlayer.new()
	button_sound.stream = load("res://Sound/Button.ogg")
	button_sound.bus = AudioServer.get_bus_name(1)
	add_child(button_sound)

#Controla el focus en el botón seleccionado, si se mueve el mouse lo deshabilita
func _process(delta):
	if get_parent().visible && !buttons.empty():
		if mouse || gui:
			buttons[button_active].release_focus()
		else:
			buttons[button_active].grab_focus()

#Control de Input
func _input(event):
	if get_parent().visible:
		
		#Variable de referencia aumenta o disminuye
		if event.is_action_released("move_up") || event.is_action_released("move_left"):
			button_active -= 1
		if event.is_action_released("move_down") || event.is_action_released("move_right"):
			button_active += 1
		
		#Control de salida
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
		
		#Control de pausa
		if event.is_action_pressed("ui_pause"):
			_sound()
			emit_signal("pause")
		
		#Controla si el mouse se mueve
		if event is InputEventMouseMotion:
			mouse = true
		
		#Vuelve a focalizar
		if event is InputEventKey:
			if !event.pressed:
				if mouse:
					if Global.current_state == "Menus": button_active = 0
					else: button_active = 1
				mouse = false
		
		#Controla si algún botón fue presionado y emite el sonido
		if event is InputEventMouseButton && event.is_pressed() || event.is_action_pressed("ui_accept"):
			for button in buttons:
				if button.is_hovered() && !button.disabled: 
					_sound()
		
		#Ciclo
		if button_active < 0:
			button_active = buttons.size() - 1
		if button_active > buttons.size() - 1:
			button_active = 0

#Reproduce el sonido
func _sound():
	if !button_sound.playing:
		button_sound.play()