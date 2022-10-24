extends Node2D

signal heroe_death()
signal health_status(health)
onready var heroe: Node
onready var heroe_atk: int

func _ready() -> void:
	for child in get_children():
		if child.name == "monk":
			heroe = $monk
			heroe_atk = heroe.get_dmg() 
		
	


func _physics_process(_delta: float) -> void:
	if !is_instance_valid(heroe):
		emit_signal("heroe_death")
	if is_instance_valid(heroe):
		if heroe.hurted == true:
			emit_signal("health_status", heroe.health)
	


func health_status(health):
	health = heroe.health


