tool
extends KinematicBody2D

export (bool) var long = false setget change_size
export (Array, Vector2) var coordinates setget add_point
var speed = 2

var points = []
var current_point = 1
var next_point = Vector2()
var global_pos = Vector2()
var back = false

func add_point(_point):
	coordinates = _point
	
	if !points.empty():
		points.clear()
	
	for i in range(0, coordinates.size()):
		points.push_back(Vector2(coordinates[i].x * 48, coordinates[i].y * 48))

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
	next_point = points[current_point] + global_pos

func _draw():
	if Engine.is_editor_hint():
		for point in range(0, points.size()):
			point = wrapi(point, 0, points.size()-1)
			draw_line(points[point], points[point + 1], Color.red, 5.0)

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
	else:
		update()