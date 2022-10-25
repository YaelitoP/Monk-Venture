extends Node2D

onready var my_child: Node
onready var child_health: int 
onready var dmg_income: = 20 setget new_dmg, actual_dmg

func _ready() -> void:
	for child in get_children():
		if child.name == "wizard":
			my_child = $wizard
			child_health = my_child.get_health()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "area_atacks":
		my_child.damage(dmg_income)


func new_dmg(dmg):
	dmg_income = dmg
	


func actual_dmg():
	return dmg_income
