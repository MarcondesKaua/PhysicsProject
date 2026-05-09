extends Node2D

@onready var line2d: Line2D = $Line2D

const MAX_POINTS = 100.0
const UPDATE_POINTS_FREQUENCY = 0.08


var target: CanonBall
var points_array: Array[Vector2] = []
var last_updated_time: float = 0.0

func _ready() -> void:
	self.line2d.points = points_array

func _process(delta: float) -> void:
	if is_instance_valid(self.target):
		self.last_updated_time +=delta
		
		if self.last_updated_time >= self.UPDATE_POINTS_FREQUENCY:
			add_points(target.global_position)
			self.last_updated_time = 0.0
	

func add_points(position: Vector2 ) ->void: 
	self.points_array.append(position)
	if self.points_array.size() > self.MAX_POINTS:
		return
	self.line2d.points = self.points_array
	

func set_trail(points : Array[Vector2]):
	self.points_array = points
