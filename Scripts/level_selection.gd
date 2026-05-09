extends CanvasLayer

var level: PackedScene
@onready var grid_conteiner: GridContainer = $TextureRect/CenterContainer/Panel/VBoxContainer/GridContainer

func _ready() -> void:
	update_level_buttons()

func _on_back_to_menu_button_pressed() -> void:
	GameManager._go_to_menu()
	

func _on_level_1_button_pressed() -> void:
	self.level = load("res://Scenes/world.tscn")
	GameManager.loading_levels(self.level)
	GameManager.actual_level += 1


func _on_level_2_button_pressed() -> void:
	self.level = load("res://Scenes/world_2.tscn")
	GameManager.loading_levels(self.level)
	GameManager.actual_level += 1

func _on_level_3_button_pressed() -> void:
	self.level = load("res://Scenes/world_3.tscn")
	GameManager.loading_levels(self.level)
	GameManager.actual_level += 1
	
func update_level_buttons():
	var buttons = self.grid_conteiner.get_children()
	for i in range(buttons.size()):
		var level_num = i + 1
		var bt = buttons[i]
				
		var status = GameManager.level_data.get(level_num, 0)
				
		match status:
			0: # Bloqueado
				bt.mouse_filter = Control.MOUSE_FILTER_IGNORE
				bt.modulate = Color(0.3, 0.3, 0.3) # Escurece o botão
				
			1: # Aberto/Pendente
				bt.mouse_filter = Control.MOUSE_FILTER_STOP
			2: # Concluído
				bt.mouse_filter = Control.MOUSE_FILTER_STOP
				bt.modulate = Color(0.5, 1, 0.5) # Tom esverdeado
