extends Node2D
class_name Target

@onready var dectectionArea: Area2D = $TargetArea
@export var distanceDirection: bool = true

var currentLocation: Vector2
var distance: float = 5.0
var currentSpeed:float = 1.0


var minX: float = 5.0
var maxX: float = 25.0
var respawnY: float = 5.0
var minSpeedScale: float = 1.0
var maxSpeedScale: float = 2.5

func _ready() -> void:
	add_to_group("target")
	self.currentLocation = global_position
	randomize_movement_speed()
	self.dectectionArea.body_entered.connect(targetHitted)

func _process(delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0 
	var offsetX = sin(time * self.currentSpeed) * self.distance
	var offsetY = sin(time * self.currentSpeed) * self.distance - 3
	if distanceDirection == true:
		global_position = self.currentLocation + Vector2(0, offsetY) # outra variavel para corrigir margem no eixo y
	else:
		global_position = self.currentLocation + Vector2(offsetX, 0)
	
	
func targetHitted (body: Node2D) -> void: 
	if body is canonBall:
		body.queue_free()
		respawn()

func respawn() -> void:
	var newX = randf_range(self.minX, self.maxX)
	self.currentLocation = Vector2(newX, self.respawnY) 
	global_position = self.currentLocation
	randomize_movement_speed()

	
func randomize_movement_speed() -> void:
	var newSpeed = randf_range(self.minSpeedScale, self.maxSpeedScale)
	self.currentSpeed = newSpeed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggleTargetMoveDirection"):
		distanceDirection= !distanceDirection
