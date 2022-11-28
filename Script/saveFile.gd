extends Node

onready var already_started: = false
onready var save_slot: = 0
onready var actual_level: = 0
onready var saved: = false
onready var fullscreen: = false
onready var last_point: = Vector2.ZERO
const save: = "res://Saves/game_data14.save"

func _ready() -> void:
	pass # Replace with function body.

func save_data():
	
	var game_save = File.new()
	
	game_save.open(save, File.WRITE)
	
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
	
	if not game_save.file_exists(save):
		return
		
	var _delete_this = get_tree().get_nodes_in_group("save")
	
	for i in _delete_this:
		i.queue_free()
		
	game_save.open(save, File.READ)
	
	while game_save.get_position() < game_save.get_len():
		
		var data = parse_json(game_save.get_line())
		
		var new_object = load(data["name"]).instance()
		
		var parent = get_node(data["parent"])
		
		parent.add_child(new_object)
		
		print(data["pos_x"], data["pos_y"])
		
		new_object.position = Vector2(data["pos_x"], data["pos_y"])
		
		for i in data.keys():
			
			if i == "name" or i == "parent" or i == "pos_y" or i == "pos_x":
				continue
				
			new_object.set(i, data[i])
			
	game_save.close()
