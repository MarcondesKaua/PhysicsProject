extends CanvasLayer
class_name CanvasInput

signal gravityChanged(newGravity : float)
signal gravityDirectionChanged(newGravityDirection: Vector2)

@onready var inputGravity = $HBoxContainer/InputGravity
var currentGravity : float = 9.8
var currentGravityDirection : Vector2 = Vector2.DOWN

func _ready() -> void:
	
	add_to_group("hud")
	self.inputGravity.text = str(self.currentGravity)
	self.inputGravity.text_submitted.connect(_on_input_gravity_text_submitted)


func _on_input_gravity_text_submitted(newText: String) -> void:
	var cleanFloatInput = newText.to_float()
	
	if cleanFloatInput >= 0:
		self.currentGravity = cleanFloatInput
		gravityChanged.emit(self.currentGravity)
		print("Gravidade nova ", currentGravity)
	else:
		self.inputGravity.text = str(self.currentGravity)


func clean_numeric_input(newLine: LineEdit) -> void:
	var textFiltred = ""
	var dotCount = 0
	var cursorPosition = newLine.caret_column
	
	for i in newLine.text:
		if i in "0123456789":
			textFiltred += i
		elif (i == "," or i== "." and dotCount == 0):
			textFiltred += "."
			dotCount += 1
	newLine.text = textFiltred
	newLine.caret_column = min (cursorPosition, textFiltred.length())

func set_gravity_direction(gravity_direction: Vector2) -> void:
	self.currentGravityDirection = gravity_direction.normalized()
	gravityDirectionChanged.emit(self.currentGravityDirection)
	print("Direção mudada")

func _on_input_gravity_text_changed(new_text: String) -> void:
	clean_numeric_input(self.inputGravity)
	

func _on_up_button_pressed() -> void:
	set_gravity_direction(Vector2.UP) 
	
func _on_down_button_pressed() -> void:
	
	set_gravity_direction(Vector2.DOWN)

func _on_right_button_pressed() -> void:
	set_gravity_direction(Vector2.RIGHT) 


func _on_left_button_pressed() -> void:
	set_gravity_direction(Vector2.LEFT)
