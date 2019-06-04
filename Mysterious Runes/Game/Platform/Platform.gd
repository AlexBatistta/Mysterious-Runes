tool
extends KinematicBody2D

export (bool) var long = false setget change_size
export (Vector2) var final_position = Vector2.ZERO

func change_size(_long):
	long = _long
	if long:
		$Sprite.region_rect = Rect2(0, 0, 192, 48)
		$CollisionShape2D.scale.x = 2
	else:
		$Sprite.region_rect = Rect2(0, 48, 96, 48)
		$CollisionShape2D.scale.x = 1

func _draw():
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, final_position, Color.red, 10)

func _process(delta):
	update()

func _ready():
	set_process(true)
	if !Engine.is_editor_hint():
		update_movement()
		$Sprite/AnimationPlayer.play("Move")

func update_movement():
	$Sprite/AnimationPlayer.get_animation("Move").track_set_key_value(0, 0, position)
	$Sprite/AnimationPlayer.get_animation("Move").track_set_key_value(0, 1, final_position + position)
	$Sprite/AnimationPlayer.get_animation("Move").track_set_key_value(0, 2, position)