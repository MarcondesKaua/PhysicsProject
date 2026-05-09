extends CanvasLayer

signal shooting_angle_defined(new_shooting_angle: float)

@export var anm_player: AnimationPlayer
@export var anm_scroll: AnimatedSprite2D 
@onready var bt_to_menu: Button = $Button
@onready var bt_back_menu: Button = $Back_to_menu_button
@onready var control_labels_vars: Control = $Control/Control
@onready var angle_Input: LineEdit = $Control/Control/bt_Angle/angle_Input

func _ready() -> void:
	self.bt_back_menu.visible = false
	self.anm_scroll.visible = false
	self.control_labels_vars.visible = false
	self.angle_Input.visible = false
	
	if GameManager.grav_inst:
		print("Sinal conectado")
		GameManager.grav_inst.menu_closed.connect(self.external_menu_closed)
	if GameManager.wind_inst:
		GameManager.wind_inst.menu_closed.connect(self.external_menu_closed)
	if GameManager.trail_inst:
		GameManager.trail_inst.menu_closed.connect(self.external_menu_closed)
	if GameManager.canon_inst:
		self.shooting_angle_defined.connect(GameManager.canon_inst.set_launch_angle)

func _on_button_pressed() -> void:
	GameManager.game_paused = true
	self.bt_to_menu.visible = false
	self.anm_player.play("Fade_in")
	self.anm_scroll.visible = true
	self.anm_scroll.play("default")
	await self.anm_scroll.animation_finished
	self.bt_back_menu.visible = true
	self.control_labels_vars.visible = true
	#self.anmPlayer.play_backwards("Fade_in")


func _on_back_to_menu_button_pressed() -> void:
	self.animation()
	self.bt_to_menu.visible = true
	self.anm_player.play_backwards("Fade_in")
	GameManager.game_paused = false

func _on_bt_gravity_pressed() -> void:
	if GameManager.grav_inst != null:
		await self.animation()
		GameManager.grav_inst.set_menu_visable(true)
	print("Grav funciona")

func _on_bt_wind_pressed() -> void:
	if GameManager.wind_inst != null:
		await self.animation()
		GameManager.wind_inst.set_menu_visable(true)
		
	print("Vent tambem funciona")

func _on_bt_trail_pressed() -> void:
	if GameManager.trail_inst != null:
		await self.animation()
		GameManager.trail_inst.set_menu_visable(true)

func animation() -> void: 
	self.control_labels_vars.visible = false
	self.bt_back_menu.visible = false
	self.anm_scroll.play_backwards("default")
	await self.anm_scroll.animation_finished 
	self.anm_scroll.visible = false
	
func external_menu_closed() -> void:
	
	print("external_menu_closed chamado!")
	if self.anm_player.is_playing():
		self.anm_player.play_backwards("Fade_in")
		await self.anm_player.animation_finished
	else:
		self.anm_player.play_backwards("Fade_in")  
		# sem await, só reseta visualmente  
	print("despausando...")
	self.bt_to_menu.visible = true
	GameManager.game_paused = false
	
	
	#self.anm_player.play_backwards("Fade_in")
	#await self.anm_player.animation_finished
	#print("animação terminou, despausando...")
	#self.bt_to_menu.visible = true
	#GameManager.game_paused = false

func _input(event: InputEvent) -> void:
	if not self.anm_scroll.visible:
		return
	if event.is_action("escape"):
		self.get_viewport().set_input_as_handled()
		_on_back_to_menu_button_pressed()

func clean_numeric_input(new_line: LineEdit) -> void:
	var text_filtred = ""
	var dot_count = 0
	var cursor_position = new_line.caret_column
	
	for i in new_line.text:
		if i in "-0123456789":
			text_filtred += i
		elif (i == "," or i == "." and dot_count == 0):
			text_filtred += "."
			dot_count += 1
	new_line.text = text_filtred
	new_line.caret_column = min(cursor_position, text_filtred.length())

func _on_bt_angle_pressed() -> void:
	self.angle_Input.visible = true

func _on_angle_input_text_changed(new_text: String) -> void:
	self.clean_numeric_input(self.angle_Input)

func _on_angle_input_text_submitted(new_text: String) -> void:
	var clean_input = new_text.to_float()
	if clean_input >= -360 and clean_input <= 360:
		print(clean_input)
		self.shooting_angle_defined.emit(clean_input)
		
		var tween = create_tween()
		tween.tween_property(angle_Input, "modulate:a", 0.0, 0.6).set_trans(Tween.TRANS_SINE)
		await tween.finished
		self.angle_Input.visible = false
		self.angle_Input.modulate.a = 1.0
	else: 
		self.angle_Input.text = ""
		self.angle_Input.placeholder_text = "Invalido"
	
