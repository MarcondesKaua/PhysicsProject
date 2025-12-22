extends Node2D

@onready var animatedSprite : AnimatedSprite2D = $CanonMuzzle
@onready var shootingPoint : Node2D = $CanonMuzzle/ShootingPoint
@onready var progressBar : ProgressBar= $ProgressBar
@export var launchForce : float = 2.5

const MAXFORCE: float = 15.0
const CHARGERATE: float = 15.0
var currentCharge: float = 0.0
var isCharging: bool = false

var currentGravity: float = 9.8
var currentGravityDirection: Vector2 = Vector2.DOWN

func _ready() -> void:
	self.animatedSprite.play("default")
	self.currentCharge = launchForce
	self.progressBar.visible = false
	self.progressBar.min_value = launchForce
	self.progressBar.max_value = MAXFORCE
	
	call_deferred("connectGravityInput")

func _process(delta: float) -> void:
	if isCharging:
		self.currentCharge += self.CHARGERATE * delta
		self.currentCharge = clamp(currentCharge, launchForce, MAXFORCE)
		self.progressBar.value = self.currentCharge
		self.progressBar.visible = true
	else:
		self.progressBar.visible = false
	
	var mousePosition = get_global_mouse_position()
	self.animatedSprite.look_at(mousePosition)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		self.isCharging = true
		self.currentCharge = launchForce
	
	if event.is_action_released("fire"):
		if self.isCharging:
			launch()
			self.isCharging = false

func launch() -> void:
	var finalLaunchForce = currentCharge
	var launchDirection = Vector2(1, 0).rotated(self.animatedSprite.rotation) 
	GameManager.launchPlayer(shootingPoint.global_position, launchDirection * finalLaunchForce, self.currentGravity)
	self.currentCharge = launchForce

func connectGravityInput () -> void:
	var hudNodes = get_tree().get_nodes_in_group("hud")
	var gravityInputScene = null
	
	for node in hudNodes: 
		if node is CanvasInput:
			gravityInputScene = node
			break
			
	if gravityInputScene:
		gravityInputScene.gravityChanged.connect(listenerGravityInput)
		gravityInputScene.gravityDirectionChanged.connect(listenerGravityDirectionInput)
		
		print("Gravidade conectada ", gravityInputScene)
	else:
		printerr("Gravidade erro")

func listenerGravityInput (newGravity: float) -> void:
	self.currentGravity = newGravity

func listenerGravityDirectionInput (newGravityDirection: Vector2) -> void:
	self.currentGravityDirection = newGravityDirection
