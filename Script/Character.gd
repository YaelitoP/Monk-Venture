extends Node2D

signal heroe_death()
 
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
	









