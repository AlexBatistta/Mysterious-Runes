tool
extends Area2D

#Script para la creación de géiseres

#Variable para la orientación (hacia arriba o abajo)
export (bool) var flip = false setget change_orientation

#Establece la posición y la orientación
func setup(_position, _flip):
	position = _position
	position.x += 48
	
	change_orientation(_flip)
	if flip:
		position.y += 96

#Cambia la orientación
func change_orientation(_flip):
	flip = _flip
	if flip:
		$Particles2D.scale.y = -1
		$Particles2D.position.y = -24
	else:
		$Particles2D.scale.y = 1
		$Particles2D.position.y = 24

#Colisión con un cuerpo, le indica su orientación
func _on_Geyser_body_entered(body):
	body._geyser($Particles2D.scale.y)
