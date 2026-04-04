extends Node2D
class_name Target

@onready var dectection_area: Area2D = $TargetArea
@export var distance_direction: bool = true

var current_location: Vector2
var distance: float = 5.0
var current_speed: float = 1.0

var min_x: float = 5.0
var max_x: float = 25.0
var respawn_y: float = 5.0
var min_speed_scale: float = 1.0
var max_speed_scale: float = 2.5

var time:float = 0.0
func _ready() -> void:
	self.add_to_group("target")
	self.current_location = self.global_position
	self.randomize_movement_speed()
	self.dectection_area.body_entered.connect(self.target_hitted)

func _process(_delta: float) -> void:
	if GameManager.game_paused:
		return
	
	self.time += _delta
	var offset_x = sin(time * self.current_speed) * self.distance
	var offset_y = sin(time * self.current_speed) * self.distance - 3
	
	if self.distance_direction == true:
		self.global_position = self.current_location + Vector2(0, offset_y) # outra variavel para corrigir margem no eixo y
	else:
		self.global_position = self.current_location + Vector2(offset_x, 0)
	
	
func target_hitted(body: Node2D) -> void: 
	self.visible = false
	if body is CanonBall:
		body.queue_free()
	
	await self.get_tree().create_timer(0.3).timeout
	
	GameManager._go_to_level_selection()

	#respawn()

func respawn() -> void:
	var new_x = randf_range(self.min_x, self.max_x)
	self.current_location = Vector2(new_x, self.respawn_y) 
	self.global_position = self.current_location
	self.randomize_movement_speed()

	
func randomize_movement_speed() -> void:
	var new_speed = randf_range(self.min_speed_scale, self.max_speed_scale)
	self.current_speed = new_speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggleTargetMoveDirection"):
		self.distance_direction = !self.distance_direction
