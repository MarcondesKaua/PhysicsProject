extends CanvasLayer

signal trail_limit_signal(limitd:int)
signal menu_closed

@export var animated_scroll: AnimatedSprite2D

@onready var menu_container: Control = $Control2
@onready var input_trail_history: LineEdit = $input_trail
@onready var check_status_bt: Button = $Control2/status/check_status
var max_trail_history: int = 0

func _ready() -> void:
	self.animated_scroll.visible = false
	self.input_trail_history.visible = false
	self.menu_container.visible = false
	self.visible = false
	self.check_status_bt.button_pressed = true

	
func _on_check_status_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		self.max_trail_history = 0
		trail_limit_signal.emit(self.max_trail_history)


func _on_bt_set_trail_amount_pressed() -> void:
	self.input_trail_history.visible = true


func clean_numeric_input(new_line: LineEdit) -> void:
	var text_filtered = ""
	var cursor_position = new_line.caret_column
	
	for i in new_line.text:
		if i in "0123456789":
			text_filtered += i
			
	new_line.text = text_filtered
	new_line.caret_column = min(cursor_position, text_filtered.length())


func _on_input_trail_text_submitted(new_text: String) -> void:
	var clean_int_input = new_text.to_int()
	
	if clean_int_input >= 0:
		self.max_trail_history = clean_int_input
		self.trail_limit_signal.emit(self.max_trail_history)
		print("Limite de histórico de rastros: ", self.max_trail_history)
	else:
		self.input_trail_history.text = str(self.max_trail_history)


func _on_input_trail_text_changed(_new_text: String) -> void:
	self.clean_numeric_input(self.input_trail_history)


func set_menu_visable(is_visible: bool) -> void:
	print("=== set_menu_visable chamado, is_visible: ", is_visible)
	print("animated_scroll é null? ", self.animated_scroll == null)
	print("self.visible antes: ", self.visible)

	if is_visible:
		self.visible = true
		self.animated_scroll.visible = true
		self.animated_scroll.play("default")
		await self.animated_scroll.animation_finished
		self.menu_container.visible = true
	else:
		self.menu_container.visible = false
		self.animated_scroll.visible = false
		self.visible = false
		
func _on_back_to_menu_button_pressed() -> void:
	self.menu_container.visible = false
	self.input_trail_history.visible = false
	
	self.animated_scroll.play_backwards("default")
	await self.animated_scroll.animation_finished
	self.set_menu_visable(false)
	
	self.menu_closed.emit()


func _input(event: InputEvent) -> void:
	if not self.visible:
		return
	if event.is_action("escape"):
		self.get_viewport().set_input_as_handled()
		self._on_back_to_menu_button_pressed()
