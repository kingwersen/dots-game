extends CharacterBody2D


# BASIC MOVEMENT VARAIABLES ---------------- #
@export var max_speed: float = 560
@export var acceleration: float = 2880
@export var turning_acceleration : float = 9600
@export var deceleration: float = 1200 # 3200
@export var rotation_speed: float = PI / 2  # Radians per second
# ------------------------------------------ #


func _ready():
	Globals.player = self

# All inputs we want to keep track of.
func get_input() -> Dictionary:
	var result = {
		"x": Input.get_axis("move_left", "move_right"),
		"y": Input.get_axis("move_forward", "move_back"),
		"r": Input.get_axis("rotate_ccw", "rotate_cw"),
	}
	if Globals.client_connection.client_has_input:
		combine_inputs(result, Globals.client_connection.client_input)
	return result

# Combine two dictionaries.
func combine_inputs(output: Dictionary, addition: Dictionary):
	output.x += (addition.move_right - addition.move_left)
	output.y += (addition.move_back - addition.move_forward)
	output.r += (addition.rotate_cw - addition.rotate_ccw)


func _physics_process(delta: float) -> void:
	tank_movement(delta)
	move_and_slide()


func tank_movement(delta: float) -> void:
	var input = get_input()

	# Apply rotation to the Player
	rotation += input.r * rotation_speed * delta
	
	# Manipulate velocity based on player direction
	var local_velocity = velocity.rotated(-rotation)
	
	# Acceleration
	local_velocity += Vector2(input.x, input.y) * acceleration * delta
	
	# Deceleration
	local_velocity.x -= min(abs(local_velocity.x), deceleration * delta) * sign(local_velocity.x)
	local_velocity.y -= min(abs(local_velocity.y), deceleration * delta) * sign(local_velocity.y)
	
	# Speed Limit
	var diagonal_speed = sqrt(pow(local_velocity.x, 2) + pow(local_velocity.y, 2))
	if diagonal_speed > max_speed:
		local_velocity *= max_speed / diagonal_speed
	
	velocity = local_velocity.rotated(rotation)
