tool
extends ParallaxBackground

var _offset = 0

func set_color(_color):
	$Background.modulate = _color

func _process(delta):
	_offset -= 0.5
	scroll_offset = Vector2(_offset, 0)

