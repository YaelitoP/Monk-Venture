extends Node2D
class_name Respawn

onready var quick_save: = false
onready var anim: = $anim_angel
onready var popUp: = $popup
onready var first_touch: = true
onready var remember_level: int setget set_level , get_level


func _ready() -> void:
	pass # Replace with function body.

func _on_area_angel_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if first_touch:
			SaveFile.new_start = false
			SaveFile.active = true
			SaveFile.last_point = self.global_position
			SaveFile.actual_level = remember_level
			popUp.visible = true
			first_touch = false
			anim.play("firstactive")
			SaveFile.save_data()
			
		elif quick_save:
			SaveFile.last_point = self.global_position
			quick_save = false
			anim.play("heal")
			SaveFile.actual_level = remember_level
			SaveFile.save_data()
			
		elif SaveFile.active:
			anim.play("activated")

func _on_area_angel_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		popUp.visible = false
		quick_save = true


func save():
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : self.get_global_position().x,
		"pos_y" : self.get_global_position().y,
		"first_touch" : first_touch,
		"remember_level" : remember_level
	}
	return game_data

func get_level():
	return remember_level
	
func set_level(level):
	remember_level = level
