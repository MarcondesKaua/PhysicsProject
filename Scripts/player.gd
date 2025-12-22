extends RigidBody2D
class_name canonBall

var gravityPlayer: float = 9.8
var gravityDirection: Vector2 = Vector2.DOWN
var wind: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if self.wind != Vector2.ZERO:
		self.apply_central_force(self.wind)
	
	var functionalGravity = self.gravityDirection.normalized() * self.gravityPlayer * self.mass
	self.apply_central_force(functionalGravity)
	
func setWind (wind: Vector2) -> void:
	self.wind = wind
