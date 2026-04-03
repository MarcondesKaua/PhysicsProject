extends CanvasLayer
class_name CanvasInput

signal gravityChanged(newGravity : float)
signal gravityDirectionChanged(newGravityDirection: Vector2)

@onready var inputGravity = $HBoxContainer/InputGravity
var currentGravity : float = 9.8
var currentGravityDirection : Vector2 = Vector2.DOWN

@onready var gravityPointer: TextureRect = $CanvasLayer/GravityMenu
@onready var anm_scroll: AnimatedSprite2D = $Control/AnimatedSprite2D

func _ready() -> void:
	
	add_to_group("hud")
	self.inputGravity.text = str(self.currentGravity)
	self.inputGravity.text_submitted.connect(_on_input_gravity_text_submitted)
	
	self.gravityPointer.visible = false


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


func _on_click_checker_pressed() -> void:
	print("foi")
	var windRose = $CanvasLayer/GravityMenu/WindRose
	var windArrow = $CanvasLayer/GravityMenu/WindRose/WindPointer
	
	# posição do mouse em relação ao canto superior esquerdo da Rosa
	var rawMousePosition = windRose.get_local_mouse_position()
	
	# metade do tamanho da Rosa para que o (0,0) seja o centro
	# Isso corrige o erro de clicar no Norte e ir para a direita
	var windRoseCenter = windRose.size / 2
	var correctedDirection = rawMousePosition - windRoseCenter
	
	#vetor de direção pura
	var applicableDirection = correctedDirection.normalized()
	set_gravity_direction(applicableDirection)
	
	
	# offset está na base, ela vai girar em torno do centro da Rosa
	windArrow.rotation = applicableDirection.angle() + deg_to_rad(90)
	
	
	self.gravityPointer.visible = false
	
	print("Gravidade setado para: ", applicableDirection, " com força: ", self.currentGravity)


func _on_gravity_button_direction_toggled(toggled_on: bool) -> void:
	print("foi")
	self.gravityPointer.visible = !self.gravityPointer.visible

func set_menu_visable (is_visible : bool) -> void:
	self.visible = is_visible


func _on_back_to_menu_button_pressed() -> void:
# 1. Esconda os containers de texto e botões IMEDIATAMENTE
	$HBoxContainer.visible = false
	$GravityButtonDirection.visible = false
	$VBoxContainer.visible = false 
	$Control2.visible = false
	
	# Se você tiver outros botões ou labels, esconda-os aqui também:
	# $SeuVBoxContainer.visible = false

	# 2. Agora sim, toca a animação de fechar o pergaminho
	self.anm_scroll.play_backwards("default")
	
	# 3. Espera o desenho sumir
	await self.anm_scroll.animation_finished
	
	# 4. Desliga o menu inteiro
	set_menu_visable(false)
