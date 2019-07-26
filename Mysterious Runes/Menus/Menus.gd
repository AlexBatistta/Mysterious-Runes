extends Control

#Script para el control total de los menús, administra y carga el menú correspondiente 

func _ready():
	#Reproduce la música del menú
	if Global.music: $MusicMenus.play()
	
	#Cambia el nivel a ninguno 
	Global.change_level(0)
	
	#Establece el color del fondo
	$ParallaxBackground.set_color()
	
	#Oculta los nodos
	_hide_nodes()
	
	#Obtiene los botones de la escena
	$KeyboardController._get_buttons()
	
	#Conecta la señal de transición
	Global.connect("transition", self, "_transition")
	
	#Animación Fade-In
	$Fade/AnimationPlayer.play("FadeIn")

#Transición
func _transition():
	$Fade/AnimationPlayer.play("FadeOut")
	_hide_nodes()

#Oculta todos los nodos mientras transiciona, menos el fondo
func _hide_nodes():
	var menus = $ListMenus.get_children()
	for menu in menus:
		menu.visible = false
	$BasicMenu.visible = false

#Visibiliza los nodos correspondientes al menú activo
func _draw_nodes():
	$ListMenus.get_node(Global.current_menu).visible = true
	$BasicMenu.visible = true
	
	#Renueva la lista de botones activos
	$KeyboardController._get_buttons()

#Control de animación y transición entre escenas
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		_draw_nodes()
	if anim_name == "FadeOut":
		if Global.current_menu == "Game":
			Global.change_scene("Game")
		else:
			$Fade/AnimationPlayer.play("FadeIn")
