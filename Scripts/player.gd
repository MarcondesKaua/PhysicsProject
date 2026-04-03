extends RigidBody2D
class_name canonBall

const DRAGCOEFICIENT: float = 0.5
const DRAGDENCITY: float = 0.1
var canonBallArea: float = 1.0

var applicableWind

const MAX_POINTS = 100.0
const UPDATE_POINTS_FREQUENCY = 0.08
var last_updated_time: float = 0.0
var points_array: Array[Vector2] = []

func _ready() -> void:
	self.mass = 1.0 
	
	canonBallArea = sqrt(self.mass)
func _physics_process(delta: float) -> void:
	var hud = get_tree().get_nodes_in_group("hud")
	for hudIndx in hud:
		
		if hudIndx is CanvasInput:
			var gravityForce = hudIndx.currentGravity
			var gravityDirection = hudIndx.currentGravityDirection
			
			var applicableGravity = (gravityForce * self.mass * gravityDirection)
			self.apply_central_force(applicableGravity)
	
	var wind = get_tree().get_nodes_in_group("wind")
	for windIndx in wind:
		if windIndx.has_method("getWindVector"):
			self.applicableWind = windIndx.getWindVector()
			self.apply_central_force(applicableWind) 
	
	var relative_speed = self.linear_velocity - self.applicableWind
	var magnitude_relative_speed = relative_speed.length()
	var dragDirection = -relative_speed.normalized()
	var dragForce = (magnitude_relative_speed * magnitude_relative_speed * DRAGCOEFICIENT * DRAGDENCITY * canonBallArea) * 0.5
	

	#isso aqui ta fazendo um fenomeno legal self.apply_central_force(dragForce * dragDirection)
	self.apply_central_force((dragForce ) * dragDirection)
	
	#VISUALMENTE parece melhor, mas acho que tem menos sentido fisico:
 	#var dragForce = (drag_relative_vector * DRAGCOEFICIENT * DRAGDENCITY * canonBallArea) * 0.5
	#self.apply_central_force((dragForce * self.mass ) * dragDirection)
	
	self.last_updated_time+=delta
	if self.last_updated_time >= self.UPDATE_POINTS_FREQUENCY:
		add_points(self.global_position)
		self.last_updated_time = 0.0
	

func add_points(position: Vector2 ) ->void: 
	self.points_array.append(position)
	if self.points_array.size() > MAX_POINTS:
		self.points_array.pop_front()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#RASTRO SÓ QUANDO MORRER (pode ser interessante)
	#var trail_scene = preload("res://Scenes/canonballtrail.tscn")
	#trail_scene= trail_scene.instantiate()
	#trail_scene.target = self
	#trail_scene.set_trail(self.points_array)
	#get_parent().add_child(trail_scene)
	queue_free()
