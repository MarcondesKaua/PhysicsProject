extends RigidBody2D
class_name canonBall

const DRAGCOEFICIENT: float = 0.5
const DRAGDENCITY: float = 0.1
var canonBallArea: float = 1.0


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
			var applicableWind = windIndx.getWindVector()
			self.apply_central_force(applicableWind) 
	
	var rawSpeed = linear_velocity
	var applicableSpeed = rawSpeed.length()
	var dragDirection = -rawSpeed.normalized()
	
	var dragForce = ((applicableSpeed * applicableSpeed) * DRAGCOEFICIENT * DRAGDENCITY * canonBallArea) * 0.5
	self.apply_central_force(dragForce * dragDirection)
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
