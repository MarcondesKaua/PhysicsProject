extends CanvasLayer

var level: PackedScene
func _on_back_to_menu_button_pressed() -> void:
	GameManager._go_to_menu()

func _on_level_1_button_pressed() -> void:
	self.level = load("res://Scenes/world.tscn")
	GameManager.loading_levels(self.level)


func _on_level_2_button_pressed() -> void:
	self.level = load("res://Scenes/world_2.tscn")
	GameManager.loading_levels(self.level)


func _on_level_3_button_pressed() -> void:
	self.level = load("res://Scenes/world_3.tscn")
	GameManager.loading_levels(self.level)
