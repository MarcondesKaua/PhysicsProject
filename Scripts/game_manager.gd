extends Node

var menu_scene = preload("res://Scenes/main_menu.tscn")
var level_selection_scene = preload("res://Scenes/level_selection.tscn")
var world_viewscene = preload("res://Scenes/world_view.tscn")
var canvasInput = preload("res://Scenes/canvas_input.tscn")

var canonBall_scene = preload("res://Scenes/canonball.tscn")
var canonScene = preload ("res://Scenes/canon.tscn")
var windScene = preload("res://Scenes/wind.tscn")


var player: canonBall = null
var world: Node2D = null
var root: Node2D = null
var camera: Camera2D = null
var wind: Node2D = null

func _ready() -> void:
	_go_to_menu()

func _go_to_menu()-> void:
	get_tree().change_scene_to_packed(self.menu_scene)

func _go_to_level_selection() -> void:
	get_tree().change_scene_to_packed(self.level_selection_scene)


func loading_levels() -> void:
	var error_scene_test = get_tree().change_scene_to_packed(self.world_viewscene)
	
	if error_scene_test:
		print ("Erro fatal de nao achar nada")
		return
		
	await get_tree().process_frame
	
	if self.world:
		setup()
	else:
		print("Erro fatal de cena")
		
		
#func setup() -> void:

	#var world_view: Node2D = self.world_viewscene.instantiate()
	#
	#
	#self.world = world_view.get_node("SubViewportContainer").get_node("SubViewport").get_node("World")
	#self.camera = self.world.get_node("Camera2D")
	
	# Instancia a UI e o Vento
	#var localCanvasInput = self.canvasInput.instantiate()
	#var wind = self.windScene.instantiate()
	#var canon = self.canonScene.instantiate()
	#
	#self.world.add_child(localCanvasInput)
	#self.world.add_child(wind)
	#self.world.add_child(canon)
	#
	#self.camera.targetPlayer(canon)
	#


func world_setup(world_ref: Node2D) -> void:
	self.world = world_ref
	setup()

func setup() -> void:
	print("Iniciando setup dos elementos...")
	
	# 1. Instanciar
	var localCanvasInput = self.canvasInput.instantiate()
	var localWind = self.windScene.instantiate()
	var localCanon = self.canonScene.instantiate()
	
	# 2. Adicionar ao Mundo
	self.world.add_child(localCanvasInput)
	self.world.add_child(localWind)
	
	# 3. LOCALIZAR A CÂMERA (Essencial!)
	# Como o world agora é o seu nível, a câmera deve estar dentro dele.
	self.camera = self.world.get_node_or_null("Camera2D")
	
	# 4. Configurar Câmera com segurança
	if self.camera != null:
		if self.camera.has_method("targetPlayer"):
			self.camera.targetPlayer(localCanon)
			print("Câmera focada no canhão.")
	else:
		print("AVISO: Câmera não encontrada no mundo. A UI pode não aparecer corretamente.")
		
		
func launchPlayer(startPosition: Vector2, launchImpulse: Vector2) -> void: 
	self.player = self.canonBall_scene.instantiate()
	self.player.global_position = startPosition
	self.world.add_child(self.player)
	#if not self.camera == null: 
		#self.camera.targetPlayer(self.player) #Focusing in canonBall
	self.player.apply_central_impulse(launchImpulse)
	
	
