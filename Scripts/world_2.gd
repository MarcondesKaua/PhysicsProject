extends Node2D

@export var cursor_anm: AnimatedSprite2D
@export var cursor_anm_player: AnimationPlayer
@export var tutorial_anm: AnimationPlayer
@export var label_anm: AnimationPlayer
@onready var label: Label = $Tutorial/Control/Label
@onready var tutorial_layer: CanvasLayer = $Tutorial

var passo_atual: int = 0
var pronto_para_avancar: bool = false

func _ready() -> void:
	self.tutorial_layer.visible = true
	self.cursor_anm.visible = false
	await get_tree().create_timer(0.6).timeout
	GameManager.game_paused = true
	
	
	self.passo_atual = 0
	self.cursor_anm.visible = true
	self.tutorial_anm.play("Fade_in")
	self.cursor_anm.play("Default")
	self.cursor_anm_player.play("DefaultControls")
	self.label_anm.play("DefaultControls")
	self.label.text = "Isso é o menu de varíaveis
	nele você controla suas habilidades"
	self.pronto_para_avancar = true
	

func _input(event: InputEvent) -> void:
	print("tsete")
	if self.pronto_para_avancar and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()
		avancar_passo_tutorial()


func avancar_passo_tutorial() -> void:
	
	self.passo_atual += 1
	print(self.passo_atual)
	
	match self.passo_atual:
		1:
			pass 
			#Se quiser colocar mais coisa de tutorial por aqui
		2:
			self.pronto_para_avancar = false
			self.tutorial_layer.visible = false
			GameManager.game_paused = false
			print("Tutorial parte 2 acabou, jogo liberado!")
			

func _on_back_to_menu_select_button_pressed() -> void:
	GameManager._go_to_level_selection()
