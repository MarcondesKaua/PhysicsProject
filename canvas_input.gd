extends CanvasLayer
class_name CanvasInput

signal gravityChanged(newGravity : float)
signal gravityDirectionChanged(newGravityDirection: Vector2)

@onready var inputGravity = $HBoxContainer/InputGravity
var currentGravity : float = 9.8
var currentGravityDirection

func _ready() -> void:
	self.inputGravity.text = str(self.currentGravity)
	self.inputGravity.text_submitted.connect(_on_input_gravity_text_submitted)
	self.currentGravityDirection = Vector2.DOWN

func _on_input_gravity_text_submitted(newText: String) -> void:
	var cleanInput = newText.replace("," , ".")
	var cleanFloatInput = cleanInput.to_float()
	
	if cleanFloatInput >= 0:
		self.currentGravity = cleanFloatInput
		gravityChanged.emit(self.currentGravity)
		print("Gravidade nova ", currentGravity)
	else:
		self.inputGravity.text = str(self.currentGravity)

func set_gravity_direction(gravity_direction: Vector2) -> void:
	self.currentGravityDirection = gravity_direction.normalized()
	gravityDirectionChanged.emit(self.currentGravityDirection)
	print("Direção mudada")

func _on_up_button_pressed() -> void:
	set_gravity_direction(Vector2.UP) 
	
func _on_down_button_pressed() -> void:
	
	set_gravity_direction(Vector2.DOWN)

func _on_right_button_pressed() -> void:
	set_gravity_direction(Vector2.RIGHT) 


func _on_left_button_pressed() -> void:
	set_gravity_direction(Vector2.LEFT)
