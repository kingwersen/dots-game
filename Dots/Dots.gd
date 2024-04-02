extends Node2D

@export var dot_scene : PackedScene
@export var num_dots : int
@export var bounding_region : Rect2
@export var radius : float
@export var color : Color


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(num_dots):
		_create_new_dot()
	Globals.dots = self

func _create_new_dot():
	var dot = dot_scene.instantiate()
	dot.set_spawn_area(bounding_region)
	dot.radius = radius
	dot.color = color
	add_child(dot)
