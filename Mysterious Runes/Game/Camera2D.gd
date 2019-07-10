extends Camera2D

#Game Endeavor camera script
#https://www.youtube.com/watch?v=sxtC7hj2ABY

const LOOK_AHEAD_FACTOR = 0.2
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

var facing = 0

onready var prev_camera_pos = get_camera_position()

func _ready():
	get_parent().connect("grounded_updated", self, "_grounded_updated")

func _process(delta):
	_check_facing()
	prev_camera_pos = get_camera_position()

func _check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		
		$ShiftTween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		$ShiftTween.start()

func _grounded_updated(is_grounded):
	drag_margin_v_enabled = !is_grounded
