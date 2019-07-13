tool
extends KinematicBody2D

export (bool) var long = false setget change_size
var speed = 2

var points : Array
var current_point = 1
var next_point = Vector2()
var global_pos = Vector2()
var back = false

func change_size(_long):
	long = _long
	if long:
		$Sprite.region_rect = Rect2(0, 0, 192, 48)
		$CollisionShape2D.scale.x = 2
	else:
		$Sprite.region_rect = Rect2(0, 48, 96, 48)
		$CollisionShape2D.scale.x = 1

func _ready():
	$Sprite.modulate = Global.color()
	global_pos = position
	points = $Path2D.curve.get_baked_points()
	next_point = points[current_point] + global_pos

func _physics_process(delta):
	if !Engine.is_editor_hint():
		if position.distance_to(next_point) < 1:
			if current_point + 1 > points.size() - 1:
				back = true
			elif current_point == 0:
				back = false 
			
			if !back: current_point += 1
			else: current_point -= 1
			
			$Sprite.scale.x = 1 if back else -1
		
		next_point = points[current_point] + global_pos
		position += (next_point - position).normalized() * speed
