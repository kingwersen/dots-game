extends Node

var player : CharacterBody2D = null
var dots : Node2D = null
var indicators : Node2D = null
var client_connection : Node2D = null

func empty_input() -> Dictionary:
	# See Godot Project Settings > Input Map
	return {
		"move_forward": 0.0,
		"move_back": 0.0,
		"move_left": 0.0,
		"move_right": 0.0,
		"rotate_cw": 0.0,
		"rotate_ccw": 0.0,
	}
