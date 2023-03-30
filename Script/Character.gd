extends Node2D

signal heroe_death()
signal health_status(health)
signal dash_status(cooldown, count)
signal exit()

onready var heroe: Node
onready var heroe_atk: int
onready var knockback: int = 0
onready var parent: Node = get_parent()

func _ready() -> void:
# warning-ignore:return_value_discarded
	if !self.is_connected("exit", parent, "change_level"):
		self.connect("exit", parent, "change_level")
# warning-ignore:return_value_discarded
	if !self.is_connected("heroe_death", parent, "game_over"):
		self.connect("heroe_death", parent, "game_over")
	
	for child in get_children():
		if child.name == "monk":
			heroe = child
			heroe_atk = heroe.get_dmg() 
			knockback = heroe.force
			
			emit_signal("health_status", heroe.health)
			
			


func _physics_process(_delta: float) -> void:
	if !is_instance_valid(heroe):
		emit_signal("heroe_death")
	if is_instance_valid(heroe):
		if heroe.hurted == true:
			emit_signal("health_status", heroe.health)
	if !is_instance_valid(heroe):
		for child in get_children():
			if child.name == "monk":
				heroe = child
				heroe_atk = heroe.get_dmg() 
				knockback = heroe.force
				
				emit_signal("health_status", heroe.health)

func save():
	
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : heroe.get_global_position().x,
		"pos_y" : heroe.get_global_position().y,
		"health" : heroe.health,
		"dmg" : heroe.dmg,

	}
	
	return game_data
	

