extends Sprite2D

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	
	look_at(mouse)
	rotation += PI / 2
