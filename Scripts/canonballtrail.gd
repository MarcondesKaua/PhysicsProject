extends Node2D

@onready var line2d: Line2D = $Line2D

const MAX_POINTS = 100.0
const UPDATE_POINTS_FREQUENCY = 0.08


var target: canonBall
var points_array: Array[Vector2] = []
var last_updated_time: float = 0.0
func _ready() -> void:
	line2d.points = points_array
func _process(delta: float) -> void:
	if is_instance_valid(target):
		last_updated_time +=delta
		
		if last_updated_time >= UPDATE_POINTS_FREQUENCY:
			add_points(target.global_position)
			last_updated_time = 0.0
	pass

func add_points(position: Vector2 ) ->void: 
	self.points_array.append(position)
	if points_array.size() > MAX_POINTS:
		points_array.pop_front()
	line2d.points = points_array
	pass

func set_trail(points : Array[Vector2]):
	self.points_array = points
