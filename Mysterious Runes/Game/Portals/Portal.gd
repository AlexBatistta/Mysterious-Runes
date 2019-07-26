tool
extends Area2D

#Script que controla el funcionamiento de los portales

export (bool) var spawn

#warning-ignore:unused_signal
signal teleport

#Reestablece las animaciones
func reset():
	$RuneKey.frame = 3
	$RuneKey/RuneIcon.frame = Global.current_level + 2
	if spawn:
		$AnimationPlayer.animation_set_next("Activate", "Teleport")
		$AnimationPlayer.play("Activate")

#Acción de colisión con el jugador si es un portal de salida
func _on_Portals_body_entered(body):
	if !spawn:
		if body.name == "Player":
			#Si tiene la "llave" del nivel, activa la animacion de teletransportación
			if Global.levelKey:
				$RuneKey.frame = 1
				$AnimationPlayer.animation_set_next("Activate", "Teleport")
				#Acción del portal sobre el jugador
				body._portal()
			$AnimationPlayer.play("Activate")

#Acción para la salida del jugador, reproduce la animación en reversa
func _on_Portals_body_exited(body):
	if !spawn:
		if body.name == "Player":
			$AnimationPlayer.play_backwards("Activate")

#Controla cuando finaliza la animación
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Teleport":
		if spawn:
			#Se "desactiva"
			$AnimationPlayer.animation_set_next("Activate", "")
			$AnimationPlayer.play_backwards("Activate")
		else:
			#Activa el menú de juego ganado
			Global.change_menu("MenuWin")
	else:
		#Para la animación
		$AnimationPlayer.stop(true)

#Teletransporte, emite la señal y reproduce el sonido
func _teleport():
	emit_signal("teleport")
	$TeleportSound.play()