extends Node2D
class_name world_manager

onready var wizard_node: = preload("res://tscn/wizard.tscn")
onready var monk_node: = preload("res://tscn/Monk.tscn")
onready var world0: = preload("res://maps/world0.tscn")
onready var ui: = preload("res://tscn/UI.tscn")
onready var start_menu: = preload("res://tscn/startMenu.tscn")
onready var angel: = preload("res://tscn/angel.tscn")
onready var doblejump: = preload("res://tscn/doblejump.tscn")
onready var options_scene: = preload("res://tscn/options.tscn")

onready var save_point: Object
onready var enemy: Object
onready var upgrade0: Object
onready var character: Object
onready var interface: Object
onready var title: Object
onready var map: Object
onready var options: Object

func _ready() -> void:
	SaveFile.load_game()
	options = options_scene.instance()
	title = start_menu.instance()
	if SaveFile.actual_level == 0:
		character = monk_node.instance()
		enemy = wizard_node.instance()
		interface = ui.instance()
		save_point = angel.instance()
		map = world0.instance()
		upgrade0 = doblejump.instance()
	
	
	if !SaveFile.already_started:
		self.add_child(title)
		SaveFile.already_started = true
	else:
		character.position = Checkpoint.last_point
		start_game()
		
# warning-ignore:return_value_discarded
	character.connect("heroe_death", self, "game_over")
	
	options.connect("closed", self, "close")
	options.connect("change_resolution", self, "resolution")
	title.connect("options_screen", self, "options_popup")
# warning-ignore:return_value_discarded
	title.connect("load_game", self, "start_game")
# warning-ignore:return_value_discarded
	title.connect("quit_game", self, "exit")
	
	if interface.has_signal("restart"):
# warning-ignore:return_value_discarded
		interface.connect("restart", self, "restart")
# warning-ignore:return_value_discarded
		interface.connect("quit_game", self, "exit")
	

func start_game():
	self.add_child(enemy)
	self.add_child(interface)
	self.add_child(character)
	self.add_child(save_point)
	self.add_child(map)
	self.add_child(upgrade0)
	enemy.position = map.spawn.position
	save_point.position = map.check.position
	upgrade0.position = map.upgrade.position
	if is_instance_valid(title):
		title.queue_free()

func restart():
	get_tree().reload_current_scene()
	
func options_popup():
	self.add_child(options)
	options.panel.popup()
	
func resolution():
	if OS.window_fullscreen == true:
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true


func close():
	remove_child(options)
	
func game_over():
	interface.gameover.visible = true

func exit():
	get_tree().quit()
