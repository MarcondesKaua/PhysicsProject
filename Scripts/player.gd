extends RigidBody2D
class_name CanonBall

const DRAG_COEFFICIENT: float = 0.5
const DRAG_DENSITY: float = 0.1
var canon_ball_area: float = 1.0

var applicable_wind

const MAX_POINTS = 100.0
const UPDATE_POINTS_FREQUENCY = 0.08
var last_updated_time: float = 0.0
var points_array: Array[Vector2] = []
var backup_velocity = Vector2.ZERO
var backup_angular = 0
func _ready() -> void:
	self.mass = 1.0 


func _physics_process(delta: float) -> void:
	
	if GameManager.game_paused:
		if self.linear_velocity != Vector2.ZERO:
			self.backup_velocity = self.linear_velocity
			self.linear_velocity = Vector2.ZERO
			self.backup_angular = self.angular_velocity
			self.angular_velocity = 0
		return
	
	if self.backup_velocity != Vector2.ZERO and self.linear_velocity == Vector2.ZERO:
		self.linear_velocity = self.backup_velocity
		self.backup_velocity = Vector2.ZERO
		self.angular_velocity = self.backup_angular
		self.backup_angular = 0
	
	var hud = get_tree().get_nodes_in_group("hud")
	for hud_indx in hud:
		
		if hud_indx is CanvasInput:
			var gravity_force = hud_indx.current_gravity
			var gravity_direction = hud_indx.current_gravity_direction
			
			var applicable_gravity = (gravity_force * self.mass * gravity_direction)
			self.apply_central_force(applicable_gravity)
	
	var wind = get_tree().get_nodes_in_group("wind")
	for wind_indx in wind:
		if wind_indx.has_method("getWindVector"):
			self.applicable_wind = wind_indx.getWindVector()
			self.apply_central_force(self.applicable_wind) 
	
	var relative_speed = self.linear_velocity - self.applicable_wind
	var magnitude_relative_speed = relative_speed.length()
	var drag_direction = -relative_speed.normalized()
	var drag_force = (magnitude_relative_speed * magnitude_relative_speed * DRAG_COEFFICIENT * DRAG_DENSITY * self.canon_ball_area) * 0.5
	

	#isso aqui ta fazendo um fenomeno legal self.apply_central_force(dragForce * dragDirection)
	self.apply_central_force((drag_force ) * drag_direction)
	
	#VISUALMENTE parece melhor, mas tem menos sentido fisico:
	#var dragForce = (drag_relative_vector * DRAGCOEFICIENT * DRAGDENCITY * canonBallArea) * 0.5
	#self.apply_central_force((dragForce * self.mass ) * dragDirection)
	
	self.last_updated_time += delta
	if self.last_updated_time >= self.UPDATE_POINTS_FREQUENCY:
		self.add_points(self.global_position)
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
	self.queue_free()
