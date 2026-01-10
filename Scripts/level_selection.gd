extends CanvasLayer



func _on_level_1_button_pressed() -> void:
	GameManager.loading_levels()


func _on_back_to_menu_button_pressed() -> void:
	GameManager._go_to_menu()
