extends Control

var buttons = []
var button_active = 0
var mouse = false

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
	
	var node2 = get_parent().get_node("BasicMenu")
	for button in node2.buttons:
		if node2.get_node(button).visible:
			buttons.push_back(node2.get_node(button))

func _process(delta):
	if get_parent().visible:
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
		
		if button_active < 0:
			button_active = buttons.size() - 1
		if button_active > buttons.size() - 1:
			button_active = 0
		
		if event is InputEventMouseMotion:
			mouse = true
		
		if event is InputEventKey:
			if !event.pressed:
				if mouse:
					if Global.current_state == "Menus": button_active = 0
					else: button_active = 1
				mouse = false