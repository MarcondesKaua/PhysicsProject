extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $CanonMuzzle
@onready var shooting_point: Node2D = $CanonMuzzle/ShootingPoint
@onready var progress_bar: ProgressBar = $ProgressBar
@export var launch_force: float = 2.5

const MAX_FORCE: float = 15.0
const CHARGE_RATE: float = 25.0
var current_charge: float = 0.0
var is_charging: bool = false


func _ready() -> void:
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
	
	var mouse_position = get_global_mouse_position()
	self.animated_sprite.look_at(mouse_position)

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.game_paused:
		return
	if event.is_action_pressed("fire"):
		self.is_charging = true
		self.current_charge = self.launch_force
	
	if event.is_action_released("fire"):
		if self.is_charging:
			self.launch()
			self.is_charging = false
			
	if event.is_action_pressed("escape"):
		GameManager._go_to_level_selection()

func launch() -> void:
	var final_launch_force = self.current_charge
	var launch_direction = Vector2.from_angle(self.animated_sprite.global_rotation)
	#Vector2(1, 0).rotated(self.animated_sprite.rotation) 
	GameManager.launch_player(self.shooting_point.global_position, launch_direction * final_launch_force)
	self.current_charge = self.launch_force
