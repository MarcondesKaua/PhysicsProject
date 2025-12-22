extends Node2D
class_name Wind

signal windChanged(newWind: float)

@onready var inputWind = $CanvasLayer/InputWindForce
@onready var checkButton: CheckButton = $CanvasLayer/CheckButton
@onready var windParticles: GPUParticles2D = $WindParticles

var windForce: float = 5
var windDirection: Vector2 = Vector2.RIGHT


func _ready() -> void:
	self.inputWind.text = str(0)
	self.checkButton.button_pressed = false
	self.windParticles.visible = false
	self.inputWind.text = str(windForce)

func _process(delta: float) -> void:
	var windActive = self.checkButton.button_pressed
	self.windParticles.emitting = windActive
	self.windParticles.visible = windActive
	self.inputWind.visible = windActive


func _input(direction: InputEvent) -> void:
	if direction.is_action_pressed("ui_up"):
		self.windDirection = Vector2.UP
		#self.windParticles.
	elif direction.is_action_pressed("ui_down"):
		self.windDirection = Vector2.DOWN
	elif direction.is_action_pressed("ui_right"):
		self.windDirection = Vector2.RIGHT
	elif direction.is_action_pressed("ui_left"):
		self.windDirection = Vector2.LEFT
	else:
		return
	changeParticles()

func changeParticles() -> void:
	if windParticles.process_material is ParticleProcessMaterial:
		var mat = windParticles.process_material as ParticleProcessMaterial
		# Ajusta a direção no material (X, Y, Z)
		mat.direction = Vector3(windDirection.x, windDirection.y, 0)


func _on_input_wind_force_text_submitted(newText: String) -> void:
	var cleanInput = newText.replace("," , ".")
	var cleanFloatInput = cleanInput.to_float()
	
	if cleanFloatInput >= 0:
		self.windForce = cleanFloatInput
		windChanged.emit(self.windForce)
		print("Novo vento", self.windForce)
	else:
		printerr("Erro fatal")
	
func getWindVector() -> Vector2:
	if !checkButton.button_pressed:
		return Vector2.ZERO
	
	return windDirection * windForce
