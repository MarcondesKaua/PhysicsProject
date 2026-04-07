extends CanvasLayer
class_name CanvasInput

signal menu_closed
signal gravity_changed(new_gravity: float)
signal gravity_direction_changed(new_gravity_direction: Vector2)

@onready var hbox: HBoxContainer = $HBoxContainer
@onready var gravity_bt: Button = $GravityButtonDirection
@onready var vbox: VBoxContainer = $VBoxContainer
@onready var control_label: Control = $Control2

@onready var input_gravity = $HBoxContainer/InputGravity
var current_gravity: float = 9.8
var current_gravity_direction: Vector2 = Vector2.DOWN

@onready var gravity_pointer: TextureRect = $CanvasLayer/GravityMenu

@export var anm_scroll: AnimatedSprite2D


func _ready() -> void:
	self.add_to_group("hud")
	self.input_gravity.text = str(self.current_gravity)
	self.input_gravity.text_submitted.connect(self._on_input_gravity_text_submitted)
	self.gravity_pointer.visible = false


func _on_input_gravity_text_submitted(new_text: String) -> void:
	var clean_float_input = new_text.to_float()
	
	if clean_float_input >= 0:
		self.current_gravity = clean_float_input
		self.gravity_changed.emit(self.current_gravity)
		print("Gravidade nova ", self.current_gravity)
	else:
		self.input_gravity.text = str(self.current_gravity)


func clean_numeric_input(new_line: LineEdit) -> void:
	var text_filtred = ""
	var dot_count = 0
	var cursor_position = new_line.caret_column
	
	for i in new_line.text:
		if i in "0123456789":
			text_filtred += i
		elif (i == "," or i == "." and dot_count == 0):
			text_filtred += "."
			dot_count += 1
	new_line.text = text_filtred
	new_line.caret_column = min(cursor_position, text_filtred.length())

func set_gravity_direction(gravity_direction: Vector2) -> void:
	self.current_gravity_direction = gravity_direction.normalized()
	self.gravity_direction_changed.emit(self.current_gravity_direction)
	print("Direção mudada")

func _on_input_gravity_text_changed(new_text: String) -> void:
	self.clean_numeric_input(self.input_gravity)
	

func _on_up_button_pressed() -> void:
	self.set_gravity_direction(Vector2.UP) 
	
func _on_down_button_pressed() -> void:
	self.set_gravity_direction(Vector2.DOWN)

func _on_right_button_pressed() -> void:
	self.set_gravity_direction(Vector2.RIGHT) 


func _on_left_button_pressed() -> void:
	self.set_gravity_direction(Vector2.LEFT)


func _on_click_checker_pressed() -> void:
	print("foi")
	var wind_rose = $CanvasLayer/GravityMenu/WindRose
	var wind_arrow = $CanvasLayer/GravityMenu/WindRose/WindPointer
	
	# posição do mouse em relação ao canto superior esquerdo da Rosa
	var raw_mouse_position = wind_rose.get_local_mouse_position()
	
	# metade do tamanho da Rosa para que o (0,0) seja o centro
	# Isso corrige o erro de clicar no Norte e ir para a direita
	var wind_rose_center = wind_rose.size / 2
	var corrected_direction = raw_mouse_position - wind_rose_center
	
	#vetor de direção pura
	var applicable_direction = corrected_direction.normalized()
	self.set_gravity_direction(applicable_direction)
	
	# offset está na base, ela vai girar em torno do centro da Rosa
	wind_arrow.rotation = applicable_direction.angle() + deg_to_rad(90)
	
	self.gravity_pointer.visible = false
	
	print("Gravidade setado para: ", applicable_direction, " com força: ", self.current_gravity)


func _on_gravity_button_direction_toggled(toggled_on: bool) -> void:
	print("foi")
	self.gravity_pointer.visible = !self.gravity_pointer.visible

func set_menu_visable(is_visible: bool) -> void:
	self.visible = is_visible
	if is_visible:
		self.hbox.visible = false
		self.vbox.visible = false
		self.gravity_bt.visible = false 
		self.control_label.visible = false
		
		self.anm_scroll.play("default")
		await self.anm_scroll.animation_finished
		
		self.hbox.visible = true
		self.vbox.visible = true
		self.gravity_bt.visible = true 
		self.control_label.visible = true

func _on_back_to_menu_button_pressed() -> void:
	self.hbox.visible = false
	self.vbox.visible = false
	self.gravity_bt.visible = false 
	self.control_label.visible = false
	
	self.anm_scroll.play_backwards("default")
	await self.anm_scroll.animation_finished
	self.set_menu_visable(false)
	
	self.menu_closed.emit()
	
func _input(event: InputEvent) -> void:
	if not self.visible:
		return
	if event.is_action("escape"):
		self.get_viewport().set_input_as_handled()
		self.gravity_pointer.visible = false
		_on_back_to_menu_button_pressed()
