extends Node2D

onready var child: Node
onready var child_health: int 
onready var dmg_income: int = 20 setget new_dmg, actual_dmg
onready var boundaris: Object

func _ready() -> void:
	for children in get_children():
		if children.name == "wizard":
			child = $wizard
			child_health = child.get_health()
		if children.name == "dragon":
			child = $dragon
			var limit: Node = $limitArea
			child.limit = limit


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "area_atacks":
		child.damage(dmg_income)


func new_dmg(dmg):
	dmg_income = dmg
	

func actual_dmg():
	return dmg_income


func save():
	
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"health" : child.health,
		"pos_x" : get_position().x,
		"pos_y" : get_position().y,
	}
	return game_data
