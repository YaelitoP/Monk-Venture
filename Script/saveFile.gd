extends Node

onready var new_start: = true
onready var actual_level: = 0
onready var active: = false
onready var fullscreen: = false

onready var last_point: = Vector2.ZERO

onready var slot: String
onready var new_slot: = true

const save: = "res://Saves/game_data.save"
const save1: = "res://Saves/game_data1.save"
const save2: = "res://Saves/game_data2.save"
const settings: = "res://Saves/config.cfg"



func _ready() -> void:
	load_config()
	if fullscreen == true:
		OS.window_fullscreen = true
	


func save_data():
	
	var game_save = File.new()
	
	game_save.open(slot, File.WRITE)
	
	var save_this = get_tree().get_nodes_in_group("save")
	
	for node in save_this:
		
		if node.name.empty():
			print("this node '%s' isn't instanced" % node.name)
			continue
			
		if !node.has_method("save"):
			print("this node '%s' don't have save" % node.name)
			continue
			
		var data = node.save()
		
		game_save.store_line(to_json(data))
		
	game_save.close()


func load_game():
	
	var game_save = File.new()
	
	if not game_save.file_exists(slot):
		return
		
	var _delete_this = get_tree().get_nodes_in_group("save")
	
	for i in _delete_this:
		i.queue_free()
		
	game_save.open(slot, File.READ)
	
	while game_save.get_position() < game_save.get_len():
		
		var data = parse_json(game_save.get_line())
		
		var new_object = load(data["name"]).instance()
		
		var parent = get_node(data["parent"])
		
		parent.add_child(new_object)
		
		new_object.position = Vector2(data["pos_x"], data["pos_y"])
		
		for i in data.keys():
			
			if i == "name" or i == "parent" or i == "pos_y" or i == "pos_x":
				continue
				
			new_object.set(i, data[i])
			
	game_save.close()


func save_config():
	
	var config = ConfigFile.new()
	
	config.set_value("settings", "resolution", fullscreen)
	
	
	config.save(settings)
	
	print(config)


func load_config():
	
	var config = ConfigFile.new()
	
	var err = config.load(settings)
	
	if err != OK:
		print("error, archive don't exist")
		return
		
	for section in config.get_sections():
		
		if section == "settings":
			fullscreen = config.get_value(section, "resolution")
