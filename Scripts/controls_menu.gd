extends CanvasLayer

@export var anm_player: AnimationPlayer
@export var anm_scroll: AnimatedSprite2D 
@onready var bt_to_menu: Button = $Button
@onready var bt_back_menu: Button = $Back_to_menu_button
@onready var control_labels_vars: Control = $Control/Control

func _ready() -> void:
	self.bt_back_menu.visible = false
	self.anm_scroll.visible = false
	self.control_labels_vars.visible = false
	
	if GameManager.grav_inst:
		GameManager.grav_inst.menu_closed.connect(self.external_menu_closed)
		

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
	
func animation() -> void: 
	self.control_labels_vars.visible = false
	self.bt_back_menu.visible = false
	self.anm_scroll.play_backwards("default")

	await self.anm_scroll.animation_finished 
	self.anm_scroll.visible = false
func external_menu_closed() -> void:
	self.anm_player.play_backwards("Fade_in")
	await self.anm_player.animation_finished
	self.bt_to_menu.visible = true
	GameManager.game_paused = false

func _input(event: InputEvent) -> void:
	if not self.anm_scroll.visible:
		return
	if event.is_action("escape"):
		self.get_viewport().set_input_as_handled()
		_on_back_to_menu_button_pressed()
