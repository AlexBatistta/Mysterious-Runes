extends Node2D

#Script que controla el tiempo de acción de los poderes de las runas
#y lo visualiza

signal power_out

func _ready():
	visible = false

func _set_power():
	var frame
	match Global.power_rune:
		"Damage": frame = 0
		"Shield": frame = 1
		"Regeneration": frame = 2
		"Slow": frame = 3
		"Poison": frame = 4
		"Paralyze": frame = 5
		"Invoke": frame = 6
		"Fly": frame = 7
	
	#Frame del poder activo
	$SpriteRune.frame = frame
	#Animación del poder
	$AnimationPlayer.play("Power")
	#Activa el contador
	if Global.power_rune != "Invoke":
		$RuneTimer.start(Global.TIME_POWER)

#Acción de cuando finaliza el tiempo
func _on_RuneTimer_timeout():
	#Detiene la animación
	$AnimationPlayer.stop()
	#Lo invisibiliza
	visible = false
	#Emite la señal para terminar
	emit_signal("power_out")
