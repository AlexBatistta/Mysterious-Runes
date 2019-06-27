tool
extends ParallaxBackground

var _offset = 0

func set_color():
	$Background.modulate = Global.color()

func _ready():
	Global.connect("change_color", self, "set_color")

func _process(delta):
	_offset -= 0.5
	scroll_offset = Vector2(_offset, 0)
	

