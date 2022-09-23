extends Node2D
class_name world_manager

onready var wizard_node: = preload("res://tscn/wizard.tscn")
onready var monk_node: = preload("res://tscn/monk.tscn")
onready var world0: = preload("res://maps/world0.tscn")
onready var ui: = preload("res://tscn/UI.tscn")
onready var start_menu: = preload("res://tscn/startMenu.tscn")
onready var angel: = preload("res://tscn/angel.tscn")
onready var save_point: Object
onready var enemy: Object
onready var character: Object
onready var interface: Object
onready var title: Object
onready var map: Object

func _ready() -> void:
	
	title = start_menu.instance()
	character = monk_node.instance()
	enemy = wizard_node.instance()
	interface = ui.instance()
	save_point = angel.instance()
	map = world0.instance()
	
	if !SaveFile.already_started:
		self.add_child(title)
		SaveFile.already_started = true
	else:
		character.position = Checkpoint.last_point
		start_game()
		
	if character.has_signal("heroe_death"):
		character.connect("heroe_death", self, "game_over")
	
	if title.has_signal("load_game") or title.has_signal("quit_game"):
		title.connect("load_game", self, "start_game")
		title.connect("quit_game", self, "exit")
	
	
	if interface.has_signal("restart"):
		interface.connect("restart", self, "restart")
		interface.connect("quit_game", self, "exit")

func start_game():
	self.add_child(enemy)
	self.add_child(interface)
	self.add_child(character)
	self.add_child(save_point)
	self.add_child(map)
	enemy.position = map.spawn.position
	save_point.position = map.check.position
	if is_instance_valid(title):
		title.queue_free()

func restart():
	get_tree().reload_current_scene()

func game_over():
	interface.gameover.visible = true
func exit():
	get_tree().quit()
