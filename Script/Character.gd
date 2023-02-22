extends Node2D

signal heroe_death()
signal health_status(health)
signal dash_status(cooldown, count)


onready var heroe: Node
onready var heroe_atk: int
onready var knockback: = 0

func _ready() -> void:
	
	for child in get_children():
		if child.name == "monk":
			heroe = $monk
			heroe_atk = heroe.get_dmg() 
			knockback = heroe.force
			
			emit_signal("health_status", heroe.health)
		# warning-ignore:return_value_discarded
			self.connect("heroe_death", get_parent(), "game_over")
			


func _physics_process(_delta: float) -> void:
	if !is_instance_valid(heroe):
		emit_signal("heroe_death")
	if is_instance_valid(heroe):
		if heroe.hurted == true:
			emit_signal("health_status", heroe.health)

func save():
	
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"health" : heroe.health,
		"dmg" : heroe.dmg,
		"pos_x" : heroe.get_global_position().x,
		"pos_y" : heroe.get_global_position().y,
	}
	
	return game_data
	

