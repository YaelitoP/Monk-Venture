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
onready var enemy1: Object
onready var enemy2: Object

onready var character: Object
onready var respawn_screen: Object
onready var title: Object

onready var map: Object
onready var map1: Object
onready var map2: Object

onready var options: Object
onready var current:  Object
onready var level: int

func _ready() -> void:
	
	slot_selection = save_scene.instance()
	options = options_scene.instance()
	title = start_menu.instance()
	character = monk_node.instance()
	respawn_screen = respawn_scene.instance()
	checkpoint = angel.instance()
	
	map = world0.instance()
	map1 = world1.instance()
	
	self.add_child(map)
	self.add_child(map1)
	self.add_child(character)
	self.add_child(respawn_screen)

	if SaveFile.new_start:
		self.add_child(title)
	else:
		load_game()
		
	level = SaveFile.actual_level
	
	if level == 0:
		current = map
	if level == 1:
		current = map1
		
	connect_all()




func connect_all():
# warning-ignore:return_value_discarded
	if !slot_selection.is_connected("continue_game", self, "load_game"):
		slot_selection.connect("continue_game", self, "load_game")
# warning-ignore:return_value_discarded
	if! slot_selection.is_connected("close", self, "close"):
		slot_selection.connect("close", self, "close")
# warning-ignore:return_value_discarded
	if !slot_selection.is_connected("start", self, "start_game"):
		slot_selection.connect("start", self, "start_game")
# warning-ignore:return_value_discarded
 if !options.is_connected("closed", self, "close"):
		options.connect("closed", self, "close")
# warning-ignore:return_value_discarded
	if !options.is_connected("change_resolution", self, "resolution"):
		options.connect("change_resolution", self, "resolution")
# warning-ignore:return_value_discarded
	if !title.is_connected("continue_game", self, "file_selection"):
		title.connect("continue_game", self, "file_selection")
# warning-ignore:return_value_discarded
	if !title.is_connected("start_game", self, "file_selection"):
		title.connect("start_game", self, "file_selection")
# warning-ignore:return_value_discarded
	if !title.is_connected("options_screen", self, "options_popup"):
		title.connect("options_screen", self, "options_popup")




func start_game():
	
	level = SaveFile.actual_level
	
	if level == 0:
		current = map
		map1.queue_free()
	if level == 1:
		current = map1
		map.queue_free()
	
	spawning()
	
	character.heroe.global_position = current.spawns.startLine
	
	if !SaveFile.new_start:
		character.heroe.global_position = SaveFile.last_point
	else:
		SaveFile.new_start = false
		SaveFile.save_data()
		
	if is_instance_valid(title):
		title.queue_free()
	


func load_game():
	
	if !is_instance_valid(character):
		character = $character
	
	connect_all()
	
	level = SaveFile.actual_level
	
	if level == 0:
		current = map
		map1.queue_free()
	if level == 1:
		current = map1
		map.queue_free()
	
	spawning()
	
	if SaveFile.respawned == true:
		character.heroe.global_position = SaveFile.last_point
	
	SaveFile.new_start = false
	if is_instance_valid(title):
		title.queue_free()
	



 
func change_level():
	
	if level == 0:
		level = 1

	
	if is_instance_valid(map):
		map.queue_free()
	if is_instance_valid(map1):
		map1.queue_free()
	
	if level == 0:
		map = world0.instance()
		self.add_child(map)
		current = map
	if level == 1:
		map1 = world1.instance()
		self.add_child(map1)
		current = map1
	
	spawning()
	
	character.heroe.global_position = current.spawns.startLine
	
	SaveFile.last_point = current.spawns.player.global_position
	SaveFile.actual_level = checkpoint.get_level()
	SaveFile.save_data()
	




func spawning():
	
	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(enemy1):
		enemy1.queue_free()
	if is_instance_valid(enemy2):
		enemy2.queue_free()
	if is_instance_valid(checkpoint):
		checkpoint.queue_free()

	if !is_instance_valid(character):
		character = $character
	
	for spawners in current.spawns.get_children():
		if spawners.name == "mobSpawn":
			if !spawners.get_children():
				enemy = wizard_node.instance()
				spawners.add_child(enemy)
			if spawners.get_child_count() > 1:
				enemy.queue_free()
		if spawners.name == "mobSpawn1":
			if !spawners.get_children():
				enemy1 = wizard_node.instance()
				spawners.add_child(enemy1)
			if spawners.get_child_count() > 1:
				enemy1.queue_free()
		if spawners.name == "mobSpawn2":
			if !spawners.get_children():
				enemy2 = wizard_node.instance()
				spawners.add_child(enemy2)
			if spawners.get_child_count() > 1:
				enemy2.queue_free()
		if spawners.name == "checkPoint":
			if !spawners.get_children():
				checkpoint = angel.instance()
				spawners.add_child(checkpoint)
				checkpoint.set_level(level)
			if spawners.get_child_count() > 1:
				checkpoint.queue_free()
	





func file_selection():
	self.add_child(slot_selection)
	slot_selection.panel.popup()


func game_over():
	respawn_screen.gameover.visible = true
	SaveFile.respawned = true
	

func resolution():
	if SaveFile.fullscreen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


func close():
	if self.is_a_parent_of(options):
		remove_child(options)
		SaveFile.save_config()
	if self.is_a_parent_of(slot_selection):
		remove_child(slot_selection)
	
func options_popup():
	self.add_child(options)
	options.panel.popup()
	
