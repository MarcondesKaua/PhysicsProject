extends Camera2D

var cam_target: Node2D = null

func _ready() -> void:
	zoom = Vector2(UnitTransformation.ds_to_px(1.0), UnitTransformation.ds_to_px(1.0))

func _physics_process(delta: float) -> void:
	if !cam_target:
		return
	self.global_position = self.cam_target.global_position 

func targetPlayer(newTarget: Node2D) -> void:
	self.cam_target = newTarget
