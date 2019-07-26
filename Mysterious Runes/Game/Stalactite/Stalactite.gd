tool
extends Area2D

#Script que controla a las estalactitas, y determina su acción
#según su orientación

export (int) var powerDamage = 15
export (bool) var flip = false setget set_flip
var speed = 10
var velocity = Vector2.DOWN
var drop = false

#Estable su orientación
func set_flip(_flip):
	flip = _flip
	rotation_degrees = 180 if flip else 0

func _ready():
	#Cambia el color
	$SpriteColor.modulate = Global.color()

func _process(delta):
	if !flip:
		#Si colisiona el RayCast, cae
		if $RayCast2D.is_colliding():
			drop = true
		
		#Movimiento hacia abajo
		if drop:
			velocity += Vector2.DOWN / 2
			position += velocity

#Colisión con las balas
func _hurt(_hit):
	#Reproduce la animación para "romperlo"
	$AnimationPlayer.play("Break")
	
	#Habilita partículas
	$Particles2D.emitting = true
	
	#Reproduce sonido
	$BreakSound.play()

#Acción de colisión
func _on_Stalactite_body_entered(body):
	if body.name == "Player":
		#Hiere al personaje
		body._hurt(powerDamage)
		#Hiere al nodo
		_hurt(0)
