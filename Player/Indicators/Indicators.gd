extends Node2D

@export var indicator_scene : PackedScene
@export var radius : float = 10
#@export var color : Color = Color.BLUE


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.indicators = self
	
	# Indicators are ordered clockwise starting from north.
	# Position/offset is relative to the Player position.
	_create_new_indicator(Vector2(  0, -50))  # North
	_create_new_indicator(Vector2( 35, -35))
	_create_new_indicator(Vector2( 50,   0))  # East
	_create_new_indicator(Vector2( 35,  35))
	_create_new_indicator(Vector2(  0,  50))  # South
	_create_new_indicator(Vector2(-35,  35))
	_create_new_indicator(Vector2(-50,   0))  # West
	_create_new_indicator(Vector2(-35, -35))

func _create_new_indicator(offset):
	var indicator = indicator_scene.instantiate()
	indicator.position = position + offset
	indicator.radius = radius
	add_child(indicator)

func _process(delta):
	queue_redraw()

func _draw():
	#for dot in Globals.dots.get_children():
	#	draw_line(Vector2(0, 0), (dot.global_position - global_position).rotated(-get_parent().rotation), Color.BLUE)
	pass
