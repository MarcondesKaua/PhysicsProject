extends Node
var canonBall_scene = preload("res://Scenes/canonball.tscn")
var world_viewscene = preload("res://Scenes/world_view.tscn")
var canvasInput = preload("res://Scenes/canvas_input.tscn")
var canonScene = preload ("res://Scenes/canon.tscn")
var windScene = preload("res://Scenes/wind.tscn")

var player: canonBall = null
var world: Node2D = null
var root: Node2D = null
var camera: Camera2D = null
var wind: Node2D = null

func setup(root_ : Node2D) -> void:
	self.wind = self.windScene.instantiate()
	var localCanvasInput = self.canvasInput.instantiate()
	self.root = root_ 
	var world_view: Node2D = self.world_viewscene.instantiate()
	world_view.name = "world_view"
	
	self.root.add_child(world_view)
	self.world = world_view.get_node("SubViewportContainer").get_node("SubViewport").get_node("World")
	self.camera = self.world.get_node("Camera2D")
	self.world.add_child(localCanvasInput)
	self.world.add_child(self.wind)
	
	var canon = self.canonScene.instantiate() # Focusing in Canon
	self.camera.targetPlayer(canon)# Focusing in Canon
	
func launchPlayer(startPosition: Vector2, launchImpulse: Vector2, gravity: float, gravityDirection: Vector2) -> void: 
	self.player = self.canonBall_scene.instantiate()
	self.player.global_position = startPosition
	self.world.add_child(self.player)
	self.player.gravityPlayer = gravity
	#if not self.camera == null: 
		#self.camera.targetPlayer(self.player) #Focusing in canonBall
	var functionalWind = Vector2.ZERO
	var windNodes = get_tree().get_nodes_in_group("wind")
	
	for node in windNodes:
		if node.has_method("getWindVector"):
			functionalWind = node.getWindVector()
	self.player.setWind(functionalWind)
	
	self.player.apply_central_impulse(launchImpulse)
	
	
