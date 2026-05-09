extends Node

var menu_controls_scene = preload("res://Scenes/controls_menu.tscn")
var menu_scene = preload("res://Scenes/main_menu.tscn")
var level_selection_scene = preload("res://Scenes/level_selection.tscn")
var world_view_scene = preload("res://Scenes/world_view.tscn")
var canvas_input_scene = preload("res://Scenes/canvas_input.tscn")
var trail_menu_scene = preload("res://Scenes/trail_menu.tscn"	)
var canon_ball_scene = preload("res://Scenes/canonball.tscn")
var canon_scene = preload ("res://Scenes/canon.tscn")
var wind_scene = preload("res://Scenes/wind.tscn")

var wind_inst : Node = null
var grav_inst : Node = null
var trail_inst : Node = null
var canon_inst : Node = null

var player: CanonBall = null
var world: Node2D = null
var root: Node2D = null
var camera: Camera2D = null
var wind: Node2D = null

var game_paused: bool = false
var vacuum_mode: bool = false

var trail_history: Array = []
var trail_amount_limit: int = 0

var actual_level: int = 0
var level_data: Dictionary = {}
const MAX_LEVEL : int = 30


func _ready() -> void:
	for i in range(1, MAX_LEVEL + 1):
		if i == 1:
			level_data[i] = 1
		else:
			level_data[i] = 0

func _go_to_menu()-> void:
	SceneTransition.change_scene(self.menu_scene)
	#get_tree().change_scene_to_packed(self.menu_scene)

func _go_to_level_selection() -> void:
	SceneTransition.change_scene(self.level_selection_scene)
	#get_tree().change_scene_to_packed(self.level_selection_scene)


func loading_levels(level_loading: PackedScene) -> void:
	await SceneTransition.change_scene(self.world_view_scene)
	await get_tree().process_frame
	var world_in_view_scene = get_tree().root.get_node("WorldView/SubViewportContainer/SubViewport/World")
	
	if world_in_view_scene:
		var level_loading_instance = level_loading.instantiate()
		world_in_view_scene.add_child(level_loading_instance)
		self.world = world_in_view_scene
		self.setup()
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

#func world_setup(world_ref: Node2D) -> void:
	#self.world = world_ref
	#setup()


func setup() -> void:
	print("Iniciando setup dos elementos...")
	 #TESSSTEE
	
	var local_canvas_input = self.canvas_input_scene.instantiate()
	var local_wind = self.wind_scene.instantiate()
	var local_trail_menu = self.trail_menu_scene.instantiate()
	
	
	self.world.add_child(local_canvas_input)
	self.world.add_child(local_wind)
	self.world.add_child(local_trail_menu)
	local_canvas_input.set_menu_visable(false)
	local_trail_menu.set_menu_visable(false)
	local_wind.set_menu_visable(false)
	

	self.grav_inst = local_canvas_input
	self.wind_inst = local_wind
	self.trail_inst = local_trail_menu
	
	
	#TESTEE ACABA AQUI
	
	
	#
	#var localCanvasInput = self.canvasInput.instantiate()
	#var localWind = self.windScene.instantiate()
	#var localCanon = self.canonScene.instantiate()
	#
	#localCanvasInput.visible = false
	#localWind.visible = false
	#
	#self.world.add_child(localCanvasInput)
	#self.world.add_child(localWind)
	#
	
	var local_controls_menu = self.menu_controls_scene.instantiate()
	self.world.add_child(local_controls_menu)
	
	local_trail_menu.trail_limit_signal.connect(self._on_trail_limit_changed)
	self._on_trail_limit_changed(2)
	#Aqui começa a bagunça
	
	#CÓDIGO INUTIL:
	#self.camera = self.world.get_node_or_null("Camera2D")
	#
	#if self.camera != null:
		#if self.camera.has_method("targetPlayer"):
			#self.camera.targetPlayer(localCanon)
			#print("Câmera focada no canhão.")
	#else:
		#print("AVISO: Câmera não encontrada no mundo. A UI pode não aparecer corretamente.")
		#
	#Até aqui, por que nao vai ? sla, mas ta inutil e funcional
func _on_trail_limit_changed(new_limit_trail: int) -> void:
	self.trail_amount_limit = new_limit_trail
	print("Novo limite rastro", self.trail_amount_limit)
	self._enforce_limit_trail()

func _enforce_limit_trail() -> void:
	if self.trail_amount_limit < 0:
		return
	while self.trail_history.size() > self.trail_amount_limit:
		var oldest_trail = self.trail_history.pop_front()
		if is_instance_valid(oldest_trail):
			oldest_trail.queue_free()

func launch_player(start_position: Vector2, launch_impulse: Vector2) -> void: 
	self.player = self.canon_ball_scene.instantiate()
	
	#RASTRO DA BOLA CONTINUAMENTE:
	var trail_scene = preload("res://Scenes/canonballtrail.tscn")
	var trail_instance = trail_scene.instantiate()
	trail_instance.target = self.player
	self.world.add_child(trail_instance)
	
	self.trail_history.append(trail_instance)
	self._enforce_limit_trail()
	
	self.player.global_position = start_position
	self.world.add_child(self.player)
	#if not self.camera == null: 
		#self.camera.targetPlayer(self.player) #Foca na bola de canhão 
	self.player.apply_central_impulse(launch_impulse)


func complete_level(level_num: int) -> void:

	level_data[level_num] = 2
	var next_level = level_num + 1
	
	if next_level <= MAX_LEVEL:
		if level_data[next_level] == 0:
			level_data[next_level] = 1
			
	print("Progresso atualizado: Nível ", level_num, " concluído!")
