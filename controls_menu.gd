extends CanvasLayer

@export var anmPlayer: AnimationPlayer
@export var anm_Scroll: AnimatedSprite2D 
@onready var bt_to_menu: Button = $Button
@onready var bt_back_menu: Button = $Back_to_menu_button
@onready var control_labels_vars : Control= $Control/Control

func _ready() -> void:
	self.bt_back_menu.visible = false
	self.anm_Scroll.visible = false
	self.control_labels_vars.visible = false

func _on_button_pressed() -> void:

	
	self.bt_to_menu.visible = false
	self.anmPlayer.play("Fade_in")
	self.anm_Scroll.visible = true
	self.anm_Scroll.play("default")
	await self.anm_Scroll.animation_finished
	self.bt_back_menu.visible = true
	self.control_labels_vars.visible = true
	#self.anmPlayer.play_backwards("Fade_in")


func _on_back_to_menu_button_pressed() -> void:
	self.control_labels_vars.visible = false
	self.bt_back_menu.visible = false
	self.anm_Scroll.play_backwards("default")
	self.anmPlayer.play_backwards("Fade_in")
	await self.anm_Scroll.animation_finished 
	self.anm_Scroll.visible = false
	self.bt_to_menu.visible = true
