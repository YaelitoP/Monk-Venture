extends Node2D
class_name Respawn

onready var quick_save: bool  = false
onready var anim: Object = $anim_angel
onready var popUp:Object = $popup
onready var first_touch:bool = true
onready var remember_level: int setget set_level , get_level



func _ready() -> void:
	if remember_level != 0 and SaveFile.actual_level != remember_level:
		SaveFile.actual_level = remember_level

	


func _on_area_angel_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if first_touch:
			
			SaveFile.new_start = false
			SaveFile.active = true
			SaveFile.last_point = self.global_position
			
			popUp.visible = true
			first_touch = false
			anim.play("firstactive")
			
			SaveFile.save_data()
			
		elif quick_save:
			SaveFile.last_point = self.global_position
			
			quick_save = false
			anim.play("heal")
			
			SaveFile.save_data()
			
		elif SaveFile.active or !first_touch:
			
			anim.play("activated")
		
	

func _on_area_angel_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		popUp.visible = false
		quick_save = true
		
	


func save():
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : self.get_position().x,
		"pos_y" : self.get_position().y,
		"first_touch" : first_touch,
		"remember_level" : remember_level
	}
	return game_data

func get_level():
	return remember_level
	
func set_level(level):
	remember_level = level
