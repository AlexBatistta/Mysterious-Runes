tool
extends Area2D

export (bool) var spawn

#warning-ignore:unused_signal
signal teleport

func reset():
	if spawn:
		$AnimationPlayer.animation_set_next("Activate", "Teleport")
		$AnimationPlayer.play("Activate")

func _on_Portals_body_entered(body):
	if !spawn:
		if body.name == "Player":
			if Global.levelKey:
				$AnimationPlayer.animation_set_next("Activate", "Teleport")
				body.portal = true
			$AnimationPlayer.play("Activate")

func _on_Portals_body_exited(body):
	if !spawn:
		if body.name == "Player":
			$AnimationPlayer.play_backwards("Activate")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Teleport":
		if spawn:
			$AnimationPlayer.animation_set_next("Activate", "")
			$AnimationPlayer.play_backwards("Activate")
		else:
			Global.change_menu("MenuWin")
	else:
		$AnimationPlayer.stop(true)