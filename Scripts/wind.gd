extends Node2D
class_name Wind

signal windChanged(newWind: float)

@onready var inputWind: LineEdit = %InputWindForce
@onready var checkButton: CheckButton = %CheckButton
@onready var windParticles: GPUParticles2D = $WindParticles
@onready var windParticlesMaterial: ParticleProcessMaterial = $WindParticles.process_material
@onready var windConteiner: HBoxContainer = $CanvasLayer/VBoxContainer/HBoxForce

var windForce: float = 5
var windDirection: Vector2 = Vector2.RIGHT


func _ready() -> void:
	add_to_group("wind")
	self.inputWind.text = str(windForce)
	self.checkButton.button_pressed = false
	self.windParticles.visible = false
	self.windConteiner.visible = false
	


func _process(delta: float) -> void:
	var windActive = self.checkButton.button_pressed
	self.windParticles.emitting = windActive
	self.windParticles.visible = windActive
	self.inputWind.visible = windActive
	self.windConteiner.visible = windActive


func _on_input_wind_force_text_submitted(newText: String) -> void:
	var cleanFloatInput = newText.to_float()
	
	if cleanFloatInput > 0:
		self.windForce = cleanFloatInput
		windChanged.emit(self.windForce)
		print("Novo vento", self.windForce)
	elif cleanFloatInput == 0:
		self.checkButton.button_pressed = false
	else:
		print("Erro fatal")



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

func _on_input_wind_force_text_changed(new_text: String) -> void:
	clean_numeric_input(self.inputWind)

func setWindDirection(windDirection: Vector2) -> void:
	self.windDirection = windDirection.normalized()
	

func getWindVector() -> Vector2:
	if !checkButton.button_pressed:
		
		return Vector2.ZERO
	
	
	return windDirection * windForce


func _on_up_button_pressed() -> void:
	setWindDirection(Vector2.UP)
	self.windParticlesMaterial.gravity = Vector3(0,-10,0)


func _on_down_button_pressed() -> void:
	setWindDirection(Vector2.DOWN)
	self.windParticlesMaterial.gravity = Vector3(0,10,0)

	
func _on_right_button_pressed() -> void:
	setWindDirection(Vector2.RIGHT)
	self.windParticlesMaterial.gravity = Vector3(10,0,0)


func _on_left_button_pressed() -> void:
	setWindDirection(Vector2.LEFT)
	self.windParticlesMaterial.gravity = Vector3(-10,0,0)
