extends Node2D
class_name Gamenode

onready var wizard_node: = preload("res://tscn/Mobs/wizard.tscn")
onready var monk_node: = preload("res://tscn/Characters/Monk.tscn")

onready var world0: = preload("res://maps/level1.tscn")
onready var world1: = preload("res://maps/level2.tscn")

onready var respawn_scene: = preload("res://tscn/Ui&Fx/respawn_scene.tscn")
onready var start_menu: = preload("res://tscn/Ui&Fx/startMenu.tscn")
onready var options_scene: = preload("res://tscn/Ui&Fx/options.tscn")
onready var save_scene: = preload("res://tscn/Ui&Fx/SaveSelectionPanel.tscn")

onready var angel: = preload("res://tscn/World/angel.tscn")

onready var slot_selection: Object
onready var checkpoint: Object
onready var enemy: Object
onready var character: Object
onready var respawn_screen: Object
onready var title: Object
onready var map: Object
onready var options: Object

onready var level: = 0

func _ready() -> void:
	
	slot_selection = save_scene.instance()
	options = options_scene.instance()
	title = start_menu.instance()
	character = monk_node.instance()
	enemy = wizard_node.instance()
	respawn_screen = respawn_scene.instance()
	checkpoint = angel.instance()
	
	
	if level != SaveFile.actual_level:
		level = SaveFile.actual_level
	if level == 0:
		map = world0.instance()
	
	if SaveFile.new_start:
		self.add_child(title)
	else:
		start_game()
		
	
# warning-ignore:return_value_discarded
	slot_selection.connect("continue_game", self, "load_game")
	
# warning-ignore:return_value_discarded
	slot_selection.connect("close", self, "close")
	
# warning-ignore:return_value_discarded
	slot_selection.connect("start", self, "start_game")
	
# warning-ignore:return_value_discarded
	options.connect("closed", self, "close")
	
# warning-ignore:return_value_discarded
	options.connect("change_resolution", self, "resolution")
	
# warning-ignore:return_value_discarded
	title.connect("continue_game", self, "file_selection")
	
# warning-ignore:return_value_discarded
	title.connect("start_game", self, "file_selection")
	
# warning-ignore:return_value_discarded
	title.connect("options_screen", self, "options_popup")
	
	

func file_selection():
	self.add_child(slot_selection)
	slot_selection.panel.popup()

func start_game():
	self.add_child(map)
	self.add_child(enemy)
	self.add_child(checkpoint)
	self.add_child(character)
	self.add_child(respawn_screen)
	
	enemy.position = map.spawns.mob.global_position
	checkpoint.position = map.spawns.check.global_position
	character.position = map.spawns.player.global_position
	
	if !SaveFile.new_start:
		character.position = SaveFile.last_point
	else:
		SaveFile.new_start = false
		
	if is_instance_valid(title):
		title.queue_free()
	

func load_game():
	self.add_child(map)
	self.add_child(enemy)
	self.add_child(checkpoint)
	self.add_child(character)
	self.add_child(respawn_screen)
	
	enemy.position = map.spawns.mob.global_position
	checkpoint.position = map.spawns.check.global_position
	
	SaveFile.load_game()
	
	if !SaveFile.new_start:
		character.position = SaveFile.last_point
	else:
		SaveFile.new_start = false
		
	if is_instance_valid(title):
		title.queue_free()
	

func options_popup():
	self.add_child(options)
	options.panel.popup()
	

func resolution():
	if SaveFile.fullscreen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false

func close():
	if self.is_a_parent_of(options):
		remove_child(options)
	if self.is_a_parent_of(slot_selection):
		remove_child(slot_selection)
	SaveFile.save_config()

func game_over():
	respawn_screen.gameover.visible = true
	

