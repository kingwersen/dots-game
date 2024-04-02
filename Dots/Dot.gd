extends Node2D

@export var radius : float = 10
@export var color : Color = Color.RED
@export var spawn_area : Rect2 = Rect2(0, 0, 0, 0)


func set_spawn_area(region):
	spawn_area = region
	spawn_area.position -= spawn_area.size / 2  # x and y are centers of the region
	move_to_random_location()

# Draw a circle representing the dot.
func _draw():
	# Draw is relative to position
	draw_circle(Vector2.ZERO, radius, color)

func _on_collision_area_body_entered(_body):
	# Move the dot to a new location when the player touches it.
	move_to_random_location()

func move_to_random_location():
	# Generate random locations until we get a valid one.
	while true:
		position.x = spawn_area.position.x + randf_range(0, spawn_area.size.x)
		position.y = spawn_area.position.y + randf_range(0, spawn_area.size.y)
		if is_valid_location():
			return

func is_valid_location():
	# Don't spawn a dot inside the player.
	if Globals.player and position.distance_to(Globals.player.position) < 100.0:
		return false
	
	# Don't spawn in the corners of the spawn area. The player can't get them.
	if position.distance_to(spawn_area.position) < 50.0:
		return false
	if position.distance_to(spawn_area.position + Vector2(spawn_area.size.x, 0)) < 50.0:
		return false
	if position.distance_to(spawn_area.position + Vector2(0, spawn_area.size.y)) < 50.0:
		return false
	if position.distance_to(spawn_area.position + Vector2(spawn_area.size.x, spawn_area.size.y)) < 50.0:
		return false
	
	return true
