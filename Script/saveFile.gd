extends Node

onready var already_started: = false
onready var save_slot: = 0
onready var actual_level: = 0
onready var saved: = false
onready var fullscreen: = false
onready var last_point: = Vector2.ZERO
const save: = "res://Saves/save_archive.save"

func _ready() -> void:
	pass # Replace with function body.

func save_data():
	var file = File.new()
	file.open(save, file.WRITE)
	file.store_var(fullscreen)
	file.store_var(actual_level)
	file.store_var(already_started)
	file.store_var(last_point)
	file.close()

func load_game():
	var file = File.new()
	file.open(save, file.READ)
	fullscreen = file.get_var()
	actual_level = file.get_var()
	already_started = file.get_var()
	last_point = file.get_var()
	file.close()
