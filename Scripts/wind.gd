extends Node2D
class_name Wind

signal windChanged(newWind: float)

@onready var inputWind: LineEdit = %InputWindForce
@onready var checkButton: CheckButton = %CheckButton
@onready var windParticles: GPUParticles2D = $WindParticles
@onready var windParticlesMaterial: ParticleProcessMaterial = $WindParticles.process_material
@onready var windConteiner: HBoxContainer = $CanvasLayer/VBoxContainer/HBoxForce

@onready var windPointer = $CanvasLayer/WindMenu
@onready var canvas = $CanvasLayer
var windForce: float = 5
var windDirection: Vector2 = Vector2.RIGHT


func _ready() -> void:
	add_to_group("wind")
	
	self.inputWind.text = str(windForce)
	self.checkButton.button_pressed = false
	self.windParticles.visible = false
	self.windConteiner.visible = false
	
	self.windPointer.visible = false
	

func _process(delta: float) -> void:
	if not self.visible:
		return
	
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
		print("Novo vento ", self.windForce)
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



#
#func _on_check_button_toggled(toggled_on: bool) -> void:
	#print("socorro d")
	#if toggled_on:
		#get_tree().paused= true
		#self.windPointer.visible = true 
	#else:
		#get_tree().paused=false
		#self.windPointer.visible = false
	#
	#self.windPointer.visible = toggled_on


func _on_wind_direction_menu_pressed() -> void:
	self.windPointer.visible = !self.windPointer.visible
	


func _on_click_checker_pressed() -> void:

	var windRose = $CanvasLayer/WindMenu/WindRose
	var windArrow = $CanvasLayer/WindMenu/WindRose/WindPointer
	
	# posição do mouse em relação ao canto superior esquerdo da Rosa
	var rawMousePosition = windRose.get_local_mouse_position()
	
	# metade do tamanho da Rosa para que o (0,0) seja o centro
	# Isso corrige o erro de clicar no Norte e ir para a direita
	var windRoseCenter = windRose.size / 2
	var correctedDirection = rawMousePosition - windRoseCenter
	
	#vetor de direção pura
	var applicableDirection = correctedDirection.normalized()
	setWindDirection(applicableDirection)
	
	
	# offset está na base, vai girar em torno do centro da Rosa
	
	windArrow.rotation = applicableDirection.angle()
	
	self.windParticlesMaterial.gravity = Vector3(applicableDirection.x * self.windForce * 10, applicableDirection.y * self.windForce * 10, 0)
	
	self.windPointer.visible = false
	self.checkButton.button_pressed = true
	
	print("Vento setado para: ", applicableDirection, " com força: ", self.windForce)
	
func set_menu_visable (is_visible : bool) -> void:
	self.visible = is_visible
	self.canvas.visible = is_visible
