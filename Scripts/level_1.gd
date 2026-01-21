extends Node2D


#func _ready() -> void:
	#GameManager.world_setup(self)
	#


func _on_back_to_menu_select_button_pressed() -> void:
	GameManager._go_to_level_selection()
