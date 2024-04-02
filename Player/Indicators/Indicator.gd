extends Node2D

@export var radius : float = 10

var max_distance : float = 1280.0  # Ignore dots beyond this distance
var value : float = 0.0

var draw_text : bool = true
var font : Font = ThemeDB.fallback_font
var font_size = 30


func _process(delta):
	value = indicator_value(global_position)
	queue_redraw()

# Draw a circle representing the dot.
func _draw():
	# Draw is relative to position
	var color = indicator_color(value)
	draw_circle(Vector2.ZERO, radius, color)
	
	if draw_text:
		var text = "%.2f" % value  # Centering text is a pain in the neck...
		var offset = position.rotated(global_rotation) - (font.get_string_size(text) / 2) + Vector2(-font_size / 2, font.get_ascent(font_size) / 2)
		draw_set_transform(Vector2.ZERO, -global_rotation, Vector2.ONE)  # Rotate text to match camera
		draw_string(font, offset, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, color)

func indicator_value(pos: Vector2) -> float:
	var value = 0
	for dot in Globals.dots.get_children():
		var distance_to_dot = pos.distance_to(dot.global_position)
		if distance_to_dot <= max_distance:
			var closeness = 1.0 - (distance_to_dot / max_distance)  # Scale from [0, 1]
			value += pow(closeness, 4)  # Increase density closer to 0
	return value

func indicator_color(value: float) -> Color:
	return Color.from_hsv(value / Globals.dots.get_children().size(), 1.0, 1.0)
