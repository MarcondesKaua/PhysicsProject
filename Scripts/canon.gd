extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $CanonMuzzle
@onready var shooting_point: Node2D = $CanonMuzzle/ShootingPoint
@onready var progress_bar: ProgressBar = $ProgressBar
@export var launch_force: float = 2.5

const MAX_FORCE: float = 15.0
const CHARGE_RATE: float = 25.0
var current_charge: float = 0.0
var is_charging: bool = false
var locked_shooting_angle: float = NAN

func _ready() -> void:
	GameManager.canon_inst = self
	self.animated_sprite.play("default")
	self.current_charge = self.launch_force
	self.progress_bar.visible = false
	self.progress_bar.min_value = self.launch_force
	self.progress_bar.max_value = self.MAX_FORCE

func _process(delta: float) -> void:
	if GameManager.game_paused:
		return
		
	if self.is_charging:
		self.current_charge += self.CHARGE_RATE * delta
		self.current_charge = clamp(self.current_charge, self.launch_force, self.MAX_FORCE)
		self.progress_bar.value = self.current_charge
		self.progress_bar.visible = true
	else:
		self.progress_bar.visible = false
	
	if is_nan(self.locked_shooting_angle):
		var mouse_position = get_global_mouse_position()
		self.animated_sprite.look_at(mouse_position)
	else:
		self.animated_sprite.global_rotation = deg_to_rad(self.locked_shooting_angle * -1.0)

func _unhandled_input(event: InputEvent) -> void:
	var is_shooting = false
	if GameManager.game_paused:
		return
	if event.is_action_pressed("fire"):
		if is_shooting:
			return
		self.is_charging = true
		self.current_charge = self.launch_force
		self.animated_sprite.play("charging")
	
	if event.is_action_released("fire"):
		if self.is_charging:
			is_shooting = true
			self.launch()
			self.is_charging = false
			self.animated_sprite.play("shooting")
			await self.animated_sprite.animation_finished
			await get_tree().create_timer(0.2).timeout
			if !self.is_charging:
				self.animated_sprite.play("default")
			is_shooting = false
				
	if event.is_action_pressed("escape"):
		GameManager._go_to_level_selection()

func launch() -> void:
	var final_launch_force = self.current_charge
	var launch_direction = Vector2.from_angle(self.animated_sprite.global_rotation)
	#Vector2(1, 0).rotated(self.animated_sprite.rotation) 
	var launch_vector = launch_direction * final_launch_force
	GameManager.launch_player(self.shooting_point.global_position, launch_vector )
	self.current_charge = self.launch_force
	self.locked_shooting_angle = NAN
	print(final_launch_force, "launch vetor: ", launch_vector.length(), launch_vector)
	
func set_launch_angle(angle_degrees: float) -> void:
	self.locked_shooting_angle = angle_degrees
