extends Node2D
class_name Wind

signal menu_closed
signal wind_changed(new_wind_speed: float)

@export var anm_scroll: AnimatedSprite2D

@onready var back_to_menu_bt: Button = $CanvasLayer/Back_to_menu_button
@onready var input_wind: LineEdit = %InputWindForce
@onready var wind_particles: GPUParticles2D = $WindParticles
@onready var wind_material: ParticleProcessMaterial = $WindParticles.process_material
@onready var wind_container: VBoxContainer = $CanvasLayer/VBoxContainer

@onready var wind_pointer_menu = $CanvasLayer/Control3/WindMenu
@onready var control_label = $CanvasLayer/Control2
@onready var control_dir = $CanvasLayer/Control3

var wind_speed_magnitude: float = 5.0
var wind_direction_unit_vector: Vector2 = Vector2.RIGHT

func _ready() -> void:
	add_to_group("wind")
	
	self.input_wind.text = str(wind_speed_magnitude)
	self.wind_particles.visible = true 
	self.set_menu_visable(false) 

func _on_input_wind_force_text_submitted(new_text: String) -> void:
	var clean_float_input = new_text.to_float()
	
	if clean_float_input > 0:
		self.wind_speed_magnitude = clean_float_input
		wind_changed.emit(self.wind_speed_magnitude)
		print("Novo vento ", self.wind_speed_magnitude)
	elif clean_float_input == 0:
		# self.checkButton.button_pressed = false # Comentado pois o checkButton não foi definido
		pass
	else:
		print("Erro fatal")

func clean_numeric_input(line_edit: LineEdit) -> void:
	var text_filtered = ""
	var dot_count = 0
	var cursor_position = line_edit.caret_column
	
	for i in line_edit.text:
		if i in "0123456789":
			text_filtered += i
		elif (i == "," or i == "." and dot_count == 0):
			text_filtered += "."
			dot_count += 1
	line_edit.text = text_filtered
	line_edit.caret_column = min(cursor_position, text_filtered.length())

func _on_input_wind_force_text_changed(new_text: String) -> void:
	clean_numeric_input(self.input_wind)

func set_wind_direction(direction: Vector2) -> void:
	self.wind_direction_unit_vector = direction.normalized()

func getWindVector() -> Vector2:
	# Retorna o Vetor Velocidade do Vento (Direção * Intensidade)
	return self.wind_direction_unit_vector * self.wind_speed_magnitude

func _on_up_button_pressed() -> void:
	set_wind_direction(Vector2.UP)
	self.wind_material.gravity = Vector3(0, -10, 0)

func _on_down_button_pressed() -> void:
	set_wind_direction(Vector2.DOWN)
	self.wind_material.gravity = Vector3(0, 10, 0)

func _on_right_button_pressed() -> void:
	set_wind_direction(Vector2.RIGHT)
	self.wind_material.gravity = Vector3(10, 0, 0)

func _on_left_button_pressed() -> void:
	set_wind_direction(Vector2.LEFT)
	self.wind_material.gravity = Vector3(-10, 0, 0)

func _on_wind_direction_menu_pressed() -> void:
	self.wind_pointer_menu.visible = !self.wind_pointer_menu.visible
	
func _on_click_checker_pressed() -> void:
	var windRose = $CanvasLayer/Control3/WindMenu/WindRose
	var windArrow = $CanvasLayer/Control3/WindMenu/WindRose/WindPointer
	
	# posição do mouse em relação ao canto superior esquerdo da Rosa
	var rawMousePosition = windRose.get_local_mouse_position()
	
	# metade do tamanho da Rosa para que o (0,0) seja o centro
	# Isso corrige o erro de clicar no Norte e ir para a direita
	var windRoseCenter = windRose.size / 2
	var correctedDirection = rawMousePosition - windRoseCenter
	
	#vetor de direção pura
	var applicableDirection = correctedDirection.normalized()
	set_wind_direction(applicableDirection)
	
	# offset está na base, vai girar em torno do centro da Rosa
	windArrow.rotation = applicableDirection.angle()
	
	self.wind_material.gravity = Vector3(applicableDirection.x * self.wind_speed_magnitude * 10, applicableDirection.y * self.wind_speed_magnitude * 10, 0)
	
	self.wind_pointer_menu.visible = false
	
	print("Vento setado para: ", applicableDirection, " com força: ", self.wind_speed_magnitude)
	
	# set_menu_visable(false) # Removido para não fechar o menu inteiro ao clicar na rosa

func set_menu_visable(is_visible: bool) -> void:
	self.visible = is_visible
	
	if is_visible:

		self.wind_container.visible = false
		self.control_label.visible = false
		self.control_dir.visible = false 
		self.back_to_menu_bt.visible = false
		
		self.anm_scroll.visible = true
		self.anm_scroll.play("default")
		await self.anm_scroll.animation_finished
		

		self.wind_container.visible = true
		self.control_label.visible = true
		self.control_dir.visible = true 
		self.back_to_menu_bt.visible = true
	else:

		self.wind_container.visible = false
		self.control_label.visible = false
		self.control_dir.visible = false
		self.back_to_menu_bt.visible = false
		self.anm_scroll.visible = false
		self.wind_pointer_menu.visible = false
		

func _on_back_to_menu_button_pressed() -> void:
	self.wind_container.visible = false
	self.control_label.visible = false
	self.control_dir.visible = false
	self.back_to_menu_bt.visible = false
	
	self.anm_scroll.play_backwards("default")
	await self.anm_scroll.animation_finished
	
	self.set_menu_visable(false)
	self.menu_closed.emit()

func _input(event: InputEvent) -> void:
	if not self.visible:
		return
	if event.is_action_pressed("escape"):
		self.get_viewport().set_input_as_handled()
		self.control_dir.visible = false
		_on_back_to_menu_button_pressed()
