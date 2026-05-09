extends CanvasLayer

@export var anmPlayer: AnimationPlayer

#@onready var colorRect:ColorRect = $ColorRect
#@onready var anmPlayer: AnimationPlayer = $AnimationPlayer


#func _ready() -> void:
	#self.colorRect.visible=false
	#
	
func change_scene(target: PackedScene):
	
	self.anmPlayer.play("Fade")
	await self.anmPlayer.animation_finished
	get_tree().change_scene_to_packed(target)
	self.anmPlayer.play_backwards("Fade")
